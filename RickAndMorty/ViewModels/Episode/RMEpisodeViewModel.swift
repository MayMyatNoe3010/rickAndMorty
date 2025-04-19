//
//  RMEpisodeViewModel.swift
//  RickAndMorty
//
//  Created by User on 22/03/2025.
//

import Foundation
import Combine

class RMEpisodeViewModel: BaseViewModel{
    
    @Published var episode: RMDataWrapper<RMEpisode> = RMDataWrapper.idle()
    
    @Published var allEpisodes: RMDataWrapper<[RMEpisode]?> = RMDataWrapper.idle()
    
    private var cancellables = Set<AnyCancellable>()
    var episodeInfo: Info? = nil
    
    func getEpisode(episodeURL: String?){
        guard let urlString = episodeURL, let url = URL(string: urlString), let request = RMRequest(url: url) else {
            print("Invalid episode URL")
            return
        }
        
        Task{
            await executeServiceCall(serviceCall: {
                try await self.fetchData(request: request, expecting: RMEpisode.self)!
            }, onStateChanged: {[weak self] state, _ in
                
                self?.episode = state
                
            }, mapResponse: { response in
                return (response, nil)
            })
        }
    }
    
    public func getInitialEpisodes() {
        Task {
            await executeServiceCall(
                serviceCall: {[weak self] () -> RMGetAllEpisodesResponse? in
                    guard let self = self else { return nil }
                    return try await self.fetchData(
                        request: .listEpisodesRequest,
                        expecting: RMGetAllEpisodesResponse.self
                    )                },
                onStateChanged: { [weak self] dataWrapper, info in
                    
                    self?.allEpisodes = dataWrapper
                    
                    self?.episodeInfo = info
                    
                },
                mapResponse: { response in
                    return (response?.results , response?.info)
                },
                loadingMessage: "Fetching episodes...",
                errorMessage: "Failed to load episodes"
            )
        }
    }
    public func getMoreEpisodes(){
        print("isLoadMore\(isLoadMore)")
        guard isLoadMore else{
            return
        }
        print("Next\(episodeInfo?.next)")
        guard let nextUrlString = episodeInfo?.next,
              let nextUrl = URL(string: nextUrlString) else {
            return
        }
        
        guard let request = RMRequest(url: nextUrl) else { return }
        Task {
            await executeServiceCall(
                serviceCall: {
                    try await self.fetchData(request: request, expecting: RMGetAllEpisodesResponse.self)!
                },
                onStateChanged: { [weak self] dataWrapper, info in
                    //print("Daata: \(dataWrapper)")
                    
                    if let newEpisodes = dataWrapper.data {
                        var existingEpisodes = self?.allEpisodes.data ?? []  // Get existing data or empty array
                        existingEpisodes?.append(contentsOf: newEpisodes)  // Append new episodes
                        
                        self?.allEpisodes = RMDataWrapper.success(existingEpisodes)
                    }
                    print("Updaate:\(self?.allEpisodes.data??.count)")
                    
                    self?.episodeInfo = info
                    
                    
                },
                mapResponse: { response in
                    return (response.results , response.info)
                },
                loadingMessage: "Fetching episodes...",
                errorMessage: "Failed to load episodes"
            )
        }
    }
    public var isLoadMore: Bool{
        return episodeInfo?.next != nil
    }
}

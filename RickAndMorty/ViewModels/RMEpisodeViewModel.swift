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
    @Published var episodes: RMDataWrapper<[RMEpisode]> = RMDataWrapper.idle()
    private var cancellables = Set<AnyCancellable>()
    private var episodeURL:String?
    
//    init(episodeURL: String? = nil) {
//        super.init()
//        self.episodeURL = episodeURL
//        self.getEpisode()
//    }
    
    func fetchEpisodeDetails(episodeURLs: [String]) {
        guard !episodeURLs.isEmpty else { return }

        Task {
                await executeServiceCall(
                    serviceCall: {
                        try await withThrowingTaskGroup(of: RMEpisode?.self) { group in
                            var episodes = [RMEpisode]()
                            
                            for urlString in episodeURLs {
                                group.addTask {
                                    guard let url = URL(string: urlString) else { return nil }
                                    guard let request = RMRequest(url: url) else{return nil}
                                    return try? await self.fetchData(request: request, expecting: RMEpisode.self)
                                }
                            }
                            
                            for try await episode in group {
                                if let episode = episode {
                                    episodes.append(episode)
                                }
                            }
                            
                            return episodes
                        }
                    },
                    onStateChanged: { [weak self] state, _ in
                        DispatchQueue.main.async {
                            self?.episodes = state
                        }
                    },
                    mapResponse: { episodes in
                        return (episodes, nil)
                    }
                )
            }

    }

    func getEpisode(){
        guard let urlString = episodeURL, let url = URL(string: urlString), let request = RMRequest(url: url) else {
                    print("Invalid episode URL")
                    return
                }

        Task{
            await executeServiceCall(serviceCall: {
                try await self.fetchData(request: request, expecting: RMEpisode.self)!
            }, onStateChanged: {[weak self] state, _ in
                DispatchQueue.main.async {
                    self?.episode = state
                }
            }, mapResponse: { response in
                return (response, nil)
            })
        }
    }
}

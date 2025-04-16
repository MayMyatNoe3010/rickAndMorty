//
//  EpisodeDetailViewModel.swift
//  RickAndMorty
//
//  Created by User on 16/04/2025.
//

import Foundation
import Combine
class RMEpisodeDetailViewModel: BaseViewModel{
    @Published var episodeDetailList: RMDataWrapper<[RMEpisode]> = RMDataWrapper.idle()
    @Published var episodeDetailSection: RMDataWrapper<[RMEpisodeSection]> = RMDataWrapper.idle()
    private var cancellables = Set<AnyCancellable>()
    private let characterViewModel =  RMCharacterViewModel()
    
    func fetchEpisodeGroupedURL(episodeURLs: [String]) {
        guard !episodeURLs.isEmpty else { return }

        Task {
                await executeServiceCall(
                    serviceCall: {
                        
                        return  try await self.fetchMultipleData(from: episodeURLs){ url in
                           
                            guard let request = RMRequest(url: url) else{return nil}
                            return try? await self.fetchData(request: request, expecting: RMEpisode.self)
                        }
                        
                        
                    },
                    onStateChanged: { [weak self] state, _ in
                        
                            self?.episodeDetailList = state
                        
                    },
                    mapResponse: { episodes in
                        return (episodes, nil)
                    }
                )
            }

    }
    
    func startEpisodeSection(for episode: RMEpisode){
        characterViewModel.fetchCharacterGroupedURL(characterURLs: episode.characters)
        characterViewModel.$characterBatchCalled
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] state in
                        switch state.state {
                        case .loading:
                            self?.episodeDetailSection = RMDataWrapper.loading("Loading")
                        case .success:
                            self?.createEpisodeSections(for: episode, characters: state.data ?? [])
                        default:
                            break
                        }
                        
                    }
                    .store(in: &cancellables)
    }
    func createEpisodeSections(for episode: RMEpisode, characters: [RMCharacter]?){
        let infoSection = createInfoSection(for: episode)
        guard let characters = characters else{
            return
        }
        let characterSection = RMEpisodeSection.character(character: characters)
        let sections = [infoSection, characterSection]
        self.episodeDetailSection = RMDataWrapper.success(sections)
        
    }
    func createInfoSection(for episode: RMEpisode) -> RMEpisodeSection{
        return RMEpisodeSection.episodeInfo(data: [
            ("Episode Name", episode.name),
            ("Air Date", episode.air_date),
            ("Episode", episode.episode),
            ("Created", episode.created.formattedDateString ?? ""),
        ])
    }

}

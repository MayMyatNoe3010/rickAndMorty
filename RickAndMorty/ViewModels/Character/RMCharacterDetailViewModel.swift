//
//  RMCharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by User on 17/04/2025.
//

import Foundation
import Combine
class RMCharacterDetailViewModel: BaseViewModel{
    @Published var characterDetailList: RMDataWrapper<[RMCharacter]> = RMDataWrapper.idle()
    @Published var characterDetailSection: RMDataWrapper<[RMCharacterSection]> = RMDataWrapper.idle()
    private var cancellables = Set<AnyCancellable>()
    private let episodeViewModel = RMEpisodeDetailViewModel()
    
    func fetchCharacterGroupedURL(characterURLs: [String]) {
        guard !characterURLs.isEmpty else { return }

        Task {
                await executeServiceCall(
                    serviceCall: {
                        
                        return  try await self.fetchMultipleData(from: characterURLs){ url in
                           
                            guard let request = RMRequest(url: url) else{return nil}
                            return try? await self.fetchData(request: request, expecting: RMCharacter.self)
                        }
                        
                        
                    },
                    onStateChanged: { [weak self] state, _ in
                        
                            self?.characterDetailList = state
                        
                    },
                    mapResponse: { characters in
                        return (characters, nil)
                    }
                )
            }

    }
    
    func startCharacterSection(for character: RMCharacter){
        episodeViewModel.fetchEpisodeGroupedURL(episodeURLs: character.episode)
        episodeViewModel.$episodeDetailList
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] state in
                        switch state.state {
                        case .loading:
                            self?.characterDetailSection = RMDataWrapper.loading("Loading")
                            
                        case .success:
                            self?.createCharacterSections(for: character, episodes: state.data ?? [])
                            
                        default:
                            break
                        }
                        
                    }
                    .store(in: &cancellables)
    }
    func createCharacterSections(for character: RMCharacter, episodes: [RMEpisode]?){
        let photoSection = RMCharacterSection.photo(image: character.image)
        let infoSection = createInfoSection(for: character)
        guard let episodes = episodes else{
            return
        }
        let episodeSection = RMCharacterSection.episode(episode: episodes)
        let sections = [photoSection,infoSection, episodeSection]
        self.characterDetailSection = RMDataWrapper.success(sections)
        
    }
    func createInfoSection(for character: RMCharacter) -> RMCharacterSection{
        return RMCharacterSection.characterInfo(data: [
            (RMType.status, character.status.rawValue),
            (RMType.gender, character.gender.rawValue),
            (RMType.type, character.type),
            (RMType.species, character.species),
            (RMType.origin, character.origin.name),
            
            (RMType.created, character.created.formattedDateString ?? ""),
            (RMType.location, character.location.name),
            (RMType.episodeCount, "\(character.episode.count)"),

        ])
    }

}

//
//  RMLocationDetailViewModel.swift
//  RickAndMorty
//
//  Created by User on 17/04/2025.
//

import Foundation
import Combine

class RMLocationDetailViewModel : BaseViewModel{
    @Published var locationDetailSection: RMDataWrapper<[RMLocationSection]> = RMDataWrapper.idle()
    private var cancellables = Set<AnyCancellable>()
    private let characterViewModel = RMCharacterViewModel()
    
    func startLocationSection(for location: RMLocation){
        characterViewModel.fetchCharacterGroupedURL(characterURLs: location.residents)
        characterViewModel.$characterBatchCalled
            .receive(on: DispatchQueue.main)
            .sink{[weak self] state in
                print("LocationDetailState:\(state)")
                switch state.state{
                case .loading:
                    self?.locationDetailSection = RMDataWrapper.loading("Loading")
                    
                case .success:
                    self?.createLocationSections(for: location, characters: state.data ?? [])
                    
                default: break
                }
            }
            .store(in: &cancellables)
    }
    
    func createLocationSections(for location: RMLocation, characters: [RMCharacter]?){
        let infoSection = createInfoSection(for: location)
                guard let characters = characters else{
            return
        }
        let characterSection = RMLocationSection.character(character: characters)
        let sections = [infoSection, characterSection]
        self.locationDetailSection = RMDataWrapper.success(sections)
        
    }
    
    func createInfoSection(for location: RMLocation) -> RMLocationSection{
        return RMLocationSection.locationInfo(data: [
            ("Location", location.name),
            ("Type", location.type),
            ("Dimension", location.dimension),
            ("Created", location.created.formattedDateString ?? ""),
        ])
    }
}

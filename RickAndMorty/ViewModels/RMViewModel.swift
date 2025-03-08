//
//  RMViewModel.swift
//  RickAndMorty
//
//  Created by User on 02/03/2025.
//

import Foundation
class RMViewModel: BaseViewModel{
    @Published var allCharacters: RMDataWrapper<[RMCharacter]> = RMDataWrapper.idle()
    
    func getAllCharacters() {
            Task {
                await executeServiceCall(
                    serviceCall: {
                        try await self.fetchData(request: .listCharactersRequests, expecting: RMGetAllCharactersResponse.self)
                    },
                    onStateChanged: { [weak self] dataWrapper in
                        DispatchQueue.main.async {
                            self?.allCharacters = dataWrapper
                        }
                    },
                    mapResponse: { response in
                        return response?.results ?? []
                    },
                    loadingMessage: "Fetching characters...",
                    errorMessage: "Failed to load characters"
                )
            }
        }

    
}

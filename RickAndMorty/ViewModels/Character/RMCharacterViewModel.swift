//
//  RMViewModel.swift
//  RickAndMorty
//
//  Created by User on 02/03/2025.
//

import Foundation
class RMCharacterViewModel: BaseViewModel{
    @Published var allCharacters: RMDataWrapper<[RMCharacter]?> = RMDataWrapper.idle()
    var characterInfo: Info? = nil
    @Published var characterDetail: RMDataWrapper<RMCharacter?> = RMDataWrapper.idle()
    @Published var characterBatchCalled: RMDataWrapper<[RMCharacter]?> = RMDataWrapper.idle()
    @Published private(set) var characterDetailSections :[RMCharacterSection] = []
    public func getInitialCharacters() {
        Task {
            await executeServiceCall(
                serviceCall: {[weak self] () -> RMGetAllCharactersResponse? in
                    guard let self = self else { return nil }
                    return try await self.fetchData(
                        request: .listCharactersRequests,
                        expecting: RMGetAllCharactersResponse.self
                    )                },
                onStateChanged: { [weak self] dataWrapper, info in
                    
                    self?.allCharacters = dataWrapper
                    self?.characterInfo = info
                    
                },
                mapResponse: { response in
                    return (response?.results , response?.info)
                },
                loadingMessage: "Fetching characters...",
                errorMessage: "Failed to load characters"
            )
        }
    }
    public func getMoreCharacters(){
        print("isLoadMore\(isLoadMore)")
        guard isLoadMore else{
            return
        }
        print("Next\(characterInfo?.next)")
        guard let nextUrlString = characterInfo?.next,
              let nextUrl = URL(string: nextUrlString) else {
            return
        }
        
        guard let request = RMRequest(url: nextUrl) else { return }
        Task {
            await executeServiceCall(
                serviceCall: {
                    try await self.fetchData(request: request, expecting: RMGetAllCharactersResponse.self)!
                },
                onStateChanged: { [weak self] dataWrapper, info in
                    //print("Daata: \(dataWrapper)")
                    
                    if let newCharacters = dataWrapper.data {
                        var existingCharacters = self?.allCharacters.data ?? []  // Get existing data or empty array
                        existingCharacters?.append(contentsOf: newCharacters)  // Append new characters
                        
                        self?.allCharacters = RMDataWrapper.success(existingCharacters)
                    }
                    print("Updaate:\(self?.allCharacters.data??.count)")
                    
                    self?.characterInfo = info
                    
                    
                },
                mapResponse: { response in
                    return (response.results , response.info)
                },
                loadingMessage: "Fetching characters...",
                errorMessage: "Failed to load characters"
            )
        }
    }
    public func getCharacterDetail(url: String){
        var requestUrl: URL {
            
            guard let validUrl = URL(string: url) else {
                fatalError("Invalid URL string: \(url)")
            }
            return validUrl
        }
        guard let request =  RMRequest(url: requestUrl) else{
            return
        }
        
        Task{
            await executeServiceCall(serviceCall: {
                try await self.fetchData(request: request, expecting: RMCharacter.self)!
            }, onStateChanged: {[weak self] dataWrapper, _ in
                
                self?.characterDetail = dataWrapper
                
                
            }, mapResponse: { response in
                return (response, nil)
            })
        }
        
    }
    
    func fetchCharacterGroupedURL(characterURLs: [String]){
        guard !characterURLs.isEmpty else{ return }
        Task{
            await executeServiceCall(serviceCall: {
                return try await self.fetchMultipleData(from: characterURLs){url in
                    guard let request = RMRequest(url: url) else{return nil}
                    return try? await self.fetchData(request: request, expecting: RMCharacter.self)
                }
            }, onStateChanged: {[weak self] state, _ in
                self?.characterBatchCalled = state
            }, mapResponse: { response in
                return (response, nil)
            }
            )
        }
    }
    
    
    public var isLoadMore: Bool{
        return characterInfo?.next != nil
    }
}

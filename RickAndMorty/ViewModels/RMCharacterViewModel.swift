//
//  RMViewModel.swift
//  RickAndMorty
//
//  Created by User on 02/03/2025.
//

import Foundation
class RMCharacterViewModel: BaseViewModel{
    @Published var allCharacters: RMDataWrapper<[RMCharacter]> = RMDataWrapper.idle()
    var characterInfo: Info? = nil
    @Published var characterDetail: RMDataWrapper<RMCharacter> = RMDataWrapper.idle()
    @Published private(set) var characterDetailSections :[SectionType] = []
    public func getInitialCharacters() {
        Task {
            await executeServiceCall(
                serviceCall: {
                    try await self.fetchData(request: .listCharactersRequests, expecting: RMGetAllCharactersResponse.self)!
                },
                onStateChanged: { [weak self] dataWrapper, info in
                    DispatchQueue.main.async {
                        self?.allCharacters = dataWrapper
                        self?.characterInfo = info
                    }
                },
                mapResponse: { response in
                    return (response.results , response.info)
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
                    DispatchQueue.main.async {
                        if let newCharacters = dataWrapper.data {
                            var existingCharacters = self?.allCharacters.data ?? []  // Get existing data or empty array
                            existingCharacters.append(contentsOf: newCharacters)  // Append new characters
                            
                            self?.allCharacters = RMDataWrapper.success(existingCharacters)
                        }
                        print("Updaate:\(self?.allCharacters.data?.count)")
                        
                        self?.characterInfo = info
                        
                    }
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
                DispatchQueue.main.async {
                    self?.characterDetail = dataWrapper
                }
                
            }, mapResponse: { response in
                return (response, nil)
            })
        }
        
    }
    
    
    public var isLoadMore: Bool{
        return characterInfo?.next != nil
    }
}

//
//  RMLocationViewModel.swift
//  RickAndMorty
//
//  Created by User on 17/04/2025.
//

import Foundation
import Combine

class RMLocationViewModel: BaseViewModel{
    @Published var allLocations: RMDataWrapper<[RMLocation]?> = RMDataWrapper.idle()
    private var cancellables = Set<AnyCancellable>()
    private var locationInfo: Info? = nil
    
    public func getInitialLocations(){
        Task{
            await executeServiceCall(serviceCall: {[weak self]() -> RMGetAllLocationsResponse? in
                guard let self = self else{
                    return nil
                }
                return try await self.fetchData(request: .listLocationsRequest, expecting: RMGetAllLocationsResponse.self)
                
            }, onStateChanged: {[weak self] dataWrapper, info in
                self?.allLocations = dataWrapper
                self?.locationInfo = info
                
            }, mapResponse: {response in
                return (response?.results, response?.info)
                
            })
        }
    }
    
    public func getMoreLocations(){
        print("isLoadMore\(isLoadMore)")
        guard isLoadMore else{
            return
        }
        print("Next\(locationInfo?.next)")
        guard let nextUrlString = locationInfo?.next,
              let nextUrl = URL(string: nextUrlString) else {
            return
        }
        
        guard let request = RMRequest(url: nextUrl) else { return }
        Task {
            await executeServiceCall(
                serviceCall: {
                    try await self.fetchData(request: request, expecting: RMGetAllLocationsResponse.self)!
                },
                onStateChanged: { [weak self] dataWrapper, info in
                    //print("Daata: \(dataWrapper)")
                    
                    if let newLocations = dataWrapper.data {
                        var existingLocations = self?.allLocations.data ?? []  // Get existing data or empty array
                        existingLocations?.append(contentsOf: newLocations)  // Append new locations
                        
                        self?.allLocations = RMDataWrapper.success(existingLocations)
                    }
                    
                    
                    self?.locationInfo = info
                    
                    
                },
                mapResponse: { response in
                    return (response.results , response.info)
                },
                loadingMessage: "Fetching locations...",
                errorMessage: "Failed to load locations"
            )
        }
    }
    public var isLoadMore: Bool{
        return locationInfo?.next != nil
    }
}

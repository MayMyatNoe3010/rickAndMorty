//
//  BaseViewModel.swift
//  RickAndMorty
//
//  Created by User on 02/03/2025.
//

import Foundation
class BaseViewModel: ObservableObject{
    func executeServiceCall<T : Codable, RMModel: Codable>(
        serviceCall: @escaping () async throws -> T,
        onStateChanged: @escaping (RMDataWrapper<RMModel>) -> Void,
        mapResponse: @escaping (T) -> RMModel,
        loadingMessage: String = "Loading...",
        errorMessage: String = "Something went wrong"
    ) async{
        onStateChanged(RMDataWrapper.loading(loadingMessage))
        
        do{
            let result: T? = try await serviceCall()
            if let result = result{
                let mappedData = mapResponse(result)
                onStateChanged(RMDataWrapper.success(mappedData))
            } else{
                onStateChanged(RMDataWrapper.error(errorMessage))
            }
        }
            catch let error{
                onStateChanged(RMDataWrapper.error(error.localizedDescription))
            }
        
    }
    
    func fetchData<T : Codable>(request: RMRequest, expecting: T.Type)async throws -> T?{
        return await withCheckedContinuation{ continuation in
            RMService.shared.execute(request, expecting: T.self){ result in
                switch result{
                case .success(let model):
                    continuation.resume(returning: model)
                    
                case .failure(let error):
                    continuation.resume(throwing: error as! Never)
                }
                
            }
            
        }
    }
}

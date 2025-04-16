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
        onStateChanged: @escaping (RMDataWrapper<RMModel>, Info?) -> Void,
        mapResponse: @escaping (T) -> (RMModel, Info?),
        loadingMessage: String = "Loading...",
        errorMessage: String = "Something went wrong"
    ) async{
        onStateChanged(RMDataWrapper.loading(loadingMessage), nil)
        
        do {
            let result = try await serviceCall()
            let (mappedData, info) = mapResponse(result)
            onStateChanged(RMDataWrapper.success(mappedData), info) // Success state
            } catch {
            onStateChanged(RMDataWrapper.error(error.localizedDescription.isEmpty ? errorMessage : error.localizedDescription), nil) // Error state
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
    
    func fetchMultipleData<T: Codable>(from urlStrings: [String], using fetcher: @escaping (URL) async throws -> T?) async throws -> [T]{
        try await withThrowingTaskGroup(of: T?.self){ group in
            var results = [T]()
            for urlString in urlStrings {
                group.addTask{
                    guard let url = URL(string: urlString) else{
                        return nil
                    }
                    return try await fetcher(url)
                }
            }
            for try await result in group{
                if let item = result{
                    results.append(item)
                }
            }
          return results
        }
    }
    
}

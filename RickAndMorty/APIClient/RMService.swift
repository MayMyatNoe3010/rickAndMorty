//
//  RMService.swift
//  RickAndMorty
//
//  Created by User on 23/02/2025.
//

import Foundation

/// Primary API service to get RM data
final class RMService{
    /// Shared singleton instance
    static let shared = RMService()
    
    /// Privatized constructor
    private init(){}
    
    enum RMServiceError: Error{
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Send API call
    /// - Parameters:
    ///   - _request: request instance
    ///   - expecting type: response type
    ///   - completion: callback with data or error
    public func execute<T: Codable>(_ request: RMRequest, expecting type: T.Type,completion: @escaping(Result<T, Error>)-> Void){
        
        guard let urlRequest = self.request(from: request) else{
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                                completion(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            
            // Decode response
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                                completion(.success(result))
            }
            catch {
                
                completion(.failure(error))
            }
        }
        task.resume()
        
    }
            
        
    
    
    //Mark: - Private
    private func request(from rmRequest: RMRequest) -> URLRequest?{
        guard let url =  rmRequest.url else{
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
    
}

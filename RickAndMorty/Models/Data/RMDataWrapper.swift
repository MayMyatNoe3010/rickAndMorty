//
//  RMDataWrapper.swift
//  RickAndMorty
//
//  Created by User on 02/03/2025.
//

import Foundation
struct RMDataWrapper<T>{
    var state: DataState = .idle
    var data: T?
    
    private init(){}
    static func idle() -> RMDataWrapper{
        return RMDataWrapper()
    }
    
    static func success(_ data: T) -> RMDataWrapper{
        var wrapper = RMDataWrapper()
        wrapper.state = .success
        wrapper.data = data
        return wrapper
    }
    
    static func loading(_ message: String) -> RMDataWrapper{
        var wrapper = RMDataWrapper()
        wrapper.state = .loading(message)
        return wrapper
    }
    
    static func error(_ errorMsg: String) -> RMDataWrapper {
        var wrapper = RMDataWrapper()
        wrapper.state = .error(errorMsg)
        return wrapper
    }

    static func noData(_ msg: String) -> RMDataWrapper {
        var wrapper = RMDataWrapper()
        wrapper.state = .noData(msg)
        return wrapper
    }

    
}
enum DataState{
    case idle
    case loading(String)
    case success
    case noData(String)
    case error(String)
}

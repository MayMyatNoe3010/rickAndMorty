//
//  RMLocation.swift
//  RickAndMorty
//
//  Created by User on 23/02/2025.
//

import Foundation

struct RMLocation: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
protocol RMLocationDataRender{
    var name: String { get }
    var type: String{get}
    var dimension: String{get}
    
}
extension RMLocation: RMLocationDataRender{}

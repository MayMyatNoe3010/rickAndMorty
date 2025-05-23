//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by User on 23/02/2025.
//

import Foundation
struct RMCharacter: Codable {
    let id: Int
    let name: String
    let status: RMCharacterStatus
    let species: String
    let type: String
    let gender: RMCharacterGender
    let origin: RMOrigin
    let location: RMSingleLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

protocol RMCharacterDataRender{
    var name: String{ get }
    var status: RMCharacterStatus{ get }
    var image: String{ get }
}

extension RMCharacter: RMCharacterDataRender{
}


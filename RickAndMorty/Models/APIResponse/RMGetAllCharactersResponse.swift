//
//  RMGetAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by User on 24/02/2025.
//

import Foundation
struct RMGetAllCharactersResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    let info: Info
    let results: [RMCharacter]
}

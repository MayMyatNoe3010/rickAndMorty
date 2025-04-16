//
//  RMEpisode.swift
//  RickAndMorty
//
//  Created by User on 23/02/2025.
//

import Foundation
struct RMEpisode: Codable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}

protocol RMEpisodeDataRender {
    var name: String { get }
    var air_date: String { get }
    var episode: String { get }
}
extension RMEpisode: RMEpisodeDataRender {}



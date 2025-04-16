//
//  RMGetAllEpisodesResponse.swift
//  RickAndMorty
//
//  Created by User on 12/04/2025.
//

import Foundation

struct RMGetAllEpisodesResponse: Codable {
    
    let info: Info
    let results: [RMEpisode]
}

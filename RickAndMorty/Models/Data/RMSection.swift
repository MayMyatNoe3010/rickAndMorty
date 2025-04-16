//
//  RMSectionType.swift
//  RickAndMorty
//
//  Created by User on 15/04/2025.
//

import Foundation
enum RMCharacterSection {
    case photo(image: String)
    case characterInfo(data: [(type: RMType, value: String)])
    case episode(episode: [ RMEpisodeDataRender])
}

enum RMEpisodeSection{
    case episodeInfo(data: [(title: String, value: String)])
    case character(character: [RMCharacterDataRender])
}

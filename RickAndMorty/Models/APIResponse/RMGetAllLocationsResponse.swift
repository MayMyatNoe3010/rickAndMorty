//
//  RMGetAllLocationsResponse.swift
//  RickAndMorty
//
//  Created by User on 17/04/2025.
//

import Foundation
struct RMGetAllLocationsResponse: Codable {
    let info: Info
    let results: [RMLocation]
}

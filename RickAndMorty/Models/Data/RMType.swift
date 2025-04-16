//
//  RMType.swift
//  RickAndMorty
//
//  Created by User on 20/03/2025.
//

import Foundation
import UIKit

enum RMType: String{
    case status
    case gender
    case type
    case species
    case origin
    case created
    case location
    case episodeCount
    
    var tintColor: UIColor {
        switch self {
        case .status:
            return .systemBlue
        case .gender:
            return .systemRed
        case .type:
            return .systemPurple
        case .species:
            return .systemGreen
        case .origin:
            return .systemOrange
        case .created:
            return .systemPink
        case .location:
            return .systemYellow
        case .episodeCount:
            return .systemMint
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .status:
            return UIImage(systemName: "bell")
        case .gender:
            return UIImage(systemName: "bell")
        case .type:
            return UIImage(systemName: "bell")
        case .species:
            return UIImage(systemName: "bell")
        case .origin:
            return UIImage(systemName: "bell")
        case .created:
            return UIImage(systemName: "bell")
        case .location:
            return UIImage(systemName: "bell")
        case .episodeCount:
            return UIImage(systemName: "bell")
        }
    }
    
    var displayTitle: String {
        switch self {
        case .status,
                .gender,
                .type,
                .species,
                .origin,
                .created,
                .location:
            return rawValue.uppercased()
        case .episodeCount:
            return "EPISODE COUNT"
        }
    }
}

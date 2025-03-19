//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by User on 09/03/2025.
//

import Foundation
import UIKit
final class RMCharacterDetailViewController: UIViewController{
    private let character : RMCharacter
    init(character: RMCharacter) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

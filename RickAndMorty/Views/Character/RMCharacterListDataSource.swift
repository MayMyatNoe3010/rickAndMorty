//
//  RMCharacterListDataSource.swift
//  RickAndMorty
//
//  Created by User on 05/03/2025.
//

import UIKit
class RMCharacterListDataSource: NSObject, UICollectionViewDataSource{
    private var characters:[RMCharacter] = []
    func updateCharacters(_ characters: [RMCharacter], collectionView: UICollectionView) {
            self.characters = characters
            print("Character count updated: \(characters.count)")
            collectionView.isHidden = false
            collectionView.reloadData()
            UIView.animate(withDuration: 0.4){
                collectionView.alpha = 1
            }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Characters: \(characters.count)")
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterItemCell.cellIdentifier, for: indexPath) as? RMCharacterItemCell else{
            fatalError("Unsupported cell")
        }
        cell.configure(with: characters[indexPath.item])
                return cell    }
    
}

class RMCharacterListViewDelegate: NSObject, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let bounds = collectionView.bounds
            let width = (bounds.width - 30) / 2

            return CGSize(
                width: width,
                height: width * 1.5
            )
    }

}


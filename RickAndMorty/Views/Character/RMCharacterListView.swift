//
//  RMCharacterListView.swift
//  RickAndMorty
//
//  Created by User on 26/02/2025.
//

import UIKit
final class RMCharacterListView: UIView{
    private let dataSource = RMCharacterListDataSource()
    private let delegate = RMCharacterListViewDelegate()
    
    private let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0 , left: 10, bottom: 0, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterItemCell.self, forCellWithReuseIdentifier: RMCharacterItemCell.cellIdentifier)
        return collectionView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        //collectionView.delegate =
        addSubview(collectionView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func updateCharacters(_ characters: [RMCharacter]){
        print("Charactes: \(characters.count)")
        dataSource.updateCharacters(characters, collectionView: collectionView)
    }
}

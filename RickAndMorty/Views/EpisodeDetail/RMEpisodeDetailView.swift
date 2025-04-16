//
//  RMEpisodeDetailView.swift
//  RickAndMorty
//
//  Created by User on 10/04/2025.
//

import UIKit

class RMEpisodeDetailView: UIView {
    public var collectionView: UICollectionView?
    private var sections: [RMEpisodeSection] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView(){
        collectionView = createCollectionView()
        guard let collectionView = collectionView else{
            return
        }
        addSubview(collectionView)
        addConstraints()
    }
    private func addConstraints(){
        guard let collectionView = collectionView else{
            return
        }
        collectionView.translatesAutoresizingMaskIntoConstraints  = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    private func createCollectionView() -> UICollectionView{
        let layout = UICollectionViewCompositionalLayout{[weak self] sectionIndex, _ in
            return self?.createSections(for: sectionIndex)
            
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RMEpisodeInfoCollectionViewCell.self, forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterItemCell.self, forCellWithReuseIdentifier: RMCharacterItemCell.cellIdentifier)
        
        return collectionView
    }
    private func createSections(for sectionIndex: Int) -> NSCollectionLayoutSection {
        guard sectionIndex < sections.count else { return createInfoSectionLayout() }
        
        switch sections[sectionIndex]{
        case .episodeInfo: return createInfoSectionLayout()
        case .character: return createCharacterLayout()
        }
    }
    
    private func createInfoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(80)
            ),
            subitems: [item]
        )
        return NSCollectionLayoutSection(group: group)
    }

    private func createCharacterLayout() -> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(
                    top: 5,
                    leading: 10,
                    bottom: 5,
                    trailing: 10
                )
        let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize:  NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(260 )
                    ),
                    subitems: [item, item]
                )
                let section = NSCollectionLayoutSection(group: group)
                return section
    }
    
    
    func setDelegateAndDataSource(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        collectionView?.delegate = delegate
        collectionView?.dataSource = dataSource
    }
    
    func configure(with sections:[RMEpisodeSection]){
        self.sections = sections
        
        collectionView?.reloadData()
    }
}

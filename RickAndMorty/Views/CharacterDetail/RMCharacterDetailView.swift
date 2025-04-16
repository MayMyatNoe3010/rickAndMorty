import UIKit

class RMCharacterDetailView: UIView {
    
    public var collectionView: UICollectionView?
    private var sections: [RMCharacterSection] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDelegateAndDataSource(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        collectionView?.delegate = delegate
        collectionView?.dataSource = dataSource
    }

    
    private func setupCollectionView() {
        collectionView = createCollectionView()
        guard let collectionView = collectionView else { return }
        
        addSubview(collectionView)
        
        addConstraints()
    }
    
    func configure(with sections: [RMCharacterSection]) {
        self.sections = sections
        collectionView?.reloadData()
    }
    
    private func addConstraints() {
        guard let collectionView = collectionView else { return }
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            return self?.createSections(for: sectionIndex)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RMCharacterPhotoCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIdentifer)
        collectionView.register(RMCharacterInfoCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifer)
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifer)
        
        return collectionView
    }

    private func createSections(for sectionIndex: Int) -> NSCollectionLayoutSection {
        guard sectionIndex < sections.count else { return createDefaultSection() }
        
        switch sections[sectionIndex] {
        case .photo:
            return createPhotoSectionLayout()
        case .characterInfo:
            return createInfoSectionLayout()
        case .episode:
            return createEpisodeSectionLayout()
        }
    }

    private func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)
        ))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)), subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }

    private func createInfoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: [item, item]
        )
        return NSCollectionLayoutSection(group: group)
    }

    private func createEpisodeSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.8),
                heightDimension: .absolute(150)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 10
        return section
    }
    
    private func createDefaultSection() -> NSCollectionLayoutSection {
        return NSCollectionLayoutSection(group: NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                               heightDimension: .absolute(50)),
            subitems: []
        ))
    }
}


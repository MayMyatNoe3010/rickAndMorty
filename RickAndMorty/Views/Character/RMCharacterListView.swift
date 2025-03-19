import UIKit

protocol RMCharacterListViewDelegate: AnyObject {
    func didSelectCharacter(_ characterListView: RMCharacterListView,selectedCharacter character: RMCharacter)
    func didScroll(_ scrollView: UIScrollView)
}

class RMCharacterListView: UIView {
    private var shouldLoadMore: Bool = false
    private var characters: [RMCharacter] = []
    weak var delegate: RMCharacterListViewDelegate?

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterItemCell.self, forCellWithReuseIdentifier: RMCharacterItemCell.cellIdentifier)
        collectionView.register(
            FooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FooterLoadingCollectionReusableView.identifier
        )

        return collectionView
    }()
    
    // Initializer with delegate
    init() {

        super.init(frame: .zero)

        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubViews(collectionView)
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
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
                           
        ])
    }

    func updateCharacters(_ characters: [RMCharacter]) {
        self.characters = characters
        print("Character count updated: \(characters.count)")
        collectionView.isHidden = false
        collectionView.reloadData()
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
    func updateShouldLoadMore(_ shouldLoad: Bool) {
        self.shouldLoadMore = shouldLoad
        DispatchQueue.main.async {
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
}

// MARK: - UICollectionViewDataSource
extension RMCharacterListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterItemCell.cellIdentifier,
            for: indexPath
        ) as? RMCharacterItemCell else {
            fatalError("Unsupported cell")
        }
        cell.configure(with: characters[indexPath.item]) // Ensure `configure` exists
        return cell
    }
    func collectionView(
            _ collectionView: UICollectionView,
            viewForSupplementaryElementOfKind kind: String,
            at indexPath: IndexPath
        ) -> UICollectionReusableView {
            guard kind == UICollectionView.elementKindSectionFooter else {
                return UICollectionReusableView()
            }

            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: FooterLoadingCollectionReusableView.identifier,
                for: indexPath
            ) as! FooterLoadingCollectionReusableView

            footer.startAnimating() 
            return footer
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldLoadMore else {
               return .zero
           }

           return CGSize(width: collectionView.frame.width,
                         height: 100)
       }

    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RMCharacterListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(self, selectedCharacter: character)
    }
}

//MARK: - ScrollView
extension RMCharacterListView: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScroll(scrollView)
    }
}

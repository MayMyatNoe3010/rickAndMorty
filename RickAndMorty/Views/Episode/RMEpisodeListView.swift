//
//  RMEpisodeListView.swift
//  RickAndMorty
//
//  Created by User on 12/04/2025.
//

import UIKit
protocol RMEpisodeListViewDelegate: AnyObject{
    func didSelectEpisode(_ episodeListView: RMEpisodeListView, selectedEpisode episode: RMEpisode)
    func didScroll(_ scrollView: UIScrollView)
}
class RMEpisodeListView: UIView {
    //Use for footerspinner visibility
    private var shouldLoadMore: Bool = false
    private var episodes: [RMEpisode] = []
    weak var delegate: RMEpisodeListViewDelegate?
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifer)
        collectionView.register(FooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier:  FooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()
    
    init(){
        super.init(frame: .zero)
        collectionView.dataSource = self
        collectionView.delegate = self
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
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
                           
        ])
    }

    func updateEpisode(_ episodes: [RMEpisode]) {
        self.episodes = episodes
        print("Episode count updated: \(episodes.count)")
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

extension RMEpisodeListView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifer, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else{
            fatalError("Unsupported cell")

        }
        cell.configure(with: episodes[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else{
            return UICollectionReusableView()
        }
        
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterLoadingCollectionReusableView.identifier, for: indexPath) as! FooterLoadingCollectionReusableView
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

extension RMEpisodeListView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 20)
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        delegate?.didSelectEpisode(self, selectedEpisode: episode)
    }

}
extension RMEpisodeListView: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.handleLoadMore {
            delegate?.didScroll(scrollView)
        }
        
    }
}

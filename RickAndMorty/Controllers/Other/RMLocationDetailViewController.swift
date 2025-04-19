//
//  RMLocationDetailViewController.swift
//  RickAndMorty
//
//  Created by User on 10/04/2025.
//

import Foundation
import UIKit
import Combine

final class RMLocationDetailViewController : UIViewController, UICollectionViewDelegate{
    
    
    private let location: RMLocation
    private let detailView: RMLocationDetailView
    private let loadingView: LoadingView
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = RMLocationDetailViewModel()
    private var sections: [RMLocationSection] = []
    
    init(location: RMLocation){
        self.location = location
        self.detailView = RMLocationDetailView(frame: .zero)
        self.loadingView = LoadingView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        title = location.name
        view.backgroundColor = .systemBackground
        detailView.setDelegateAndDataSource(delegate: self, dataSource: self)
        setupUI()
        observeViewModel()
        viewModel.startLocationSection(for: location)
    }
    private func setupUI() {
        detailView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViews(detailView, loadingView)
        
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        loadingView.hide()
    }
    private func observeViewModel(){
        viewModel.$locationDetailSection
            .receive(on: DispatchQueue.main)
            .sink{[weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
    }
    private func handleState(_ state: RMDataWrapper<[RMLocationSection]>){
        
        switch(state.state){
            
        case .loading(_):
            loadingView.show()
            break
        case .success:
            loadingView.hide()
            sections = state.data ?? []
            detailView.configure(with: state.data ?? [])
            break
        case .noData, .error:
            loadingView.hide()
            break
        default: break
        }
    }
    
}

extension RMLocationDetailViewController : UICollectionViewDataSource{
    
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            print("Count: \(sections.count)")
            return sections.count
        }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard sections.indices.contains(section) else {
            return 0
        }

        switch sections[section]{
        case .locationInfo(let data): return data.count
        case .character(let character): return character.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        
        switch section {
        case .character(let character):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterItemCell.cellIdentifier, for: indexPath) as? RMCharacterItemCell else {
                fatalError("Failed to dequeue CollectionViewCell")
            }
            let info = character[indexPath.row]
            cell.configure(with: info as! RMCharacter )
            return cell
            
        case .locationInfo(let data):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier, for: indexPath) as? RMEpisodeInfoCollectionViewCell else {
                fatalError("Failed to dequeue CollectionViewCell")
            }
            let info = data[indexPath.row]
            cell.configure(with: info.title, value: info.value)
            return cell
        }
    }

}

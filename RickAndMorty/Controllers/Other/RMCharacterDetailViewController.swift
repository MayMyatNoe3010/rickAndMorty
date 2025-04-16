//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by User on 09/03/2025.
//

import Foundation
import UIKit
import Combine

final class RMCharacterDetailViewController: UIViewController, UICollectionViewDelegate {
    
    private let viewModel: RMCharacterViewModel
    private let character: RMCharacter
    private let detailView: RMCharacterDetailView
    private let loadingView: LoadingView
    private var episodeViewModel = RMEpisodeDetailViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var sections: [RMCharacterSection] = []
    
    init(character: RMCharacter, viewModel: RMCharacterViewModel) {
        self.character = character
        self.viewModel = viewModel
        self.detailView = RMCharacterDetailView(frame: .zero)
        self.loadingView = LoadingView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        title = character.name
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action, target: self, action: #selector(didTapShare)
        )

        detailView.setDelegateAndDataSource(delegate: self, dataSource: self)
        setupUI()
        bindViewModel()
        viewModel.getCharacterDetail(url: character.url)
    }

    @objc
    private func didTapShare() {
        // Implement share action if needed
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

    private func bindViewModel() {
        viewModel.$characterDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                
                    self?.handleState(state)
                
            }
            .store(in: &cancellables)
        
        episodeViewModel.$episodeDetailList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state.state {
                case .success:
                    self?.appendEpisodesToSections(state.data)
                    self?.loadingView.hide()
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }

    private func handleState(_ state: RMDataWrapper<RMCharacter?>) {
        switch state.state {
        case .loading(_):
            loadingView.show()
            break
        case .success:
            guard let episodes = state.data??.episode else { return }
            episodeViewModel.fetchEpisodeGroupedURL(episodeURLs: episodes)
            if let data = state.data{
                createSections(state.data as! RMCharacter)
            }
            break
        case .noData, .error:
            loadingView.hide()
            break
        default:
            break
        }
    }

    private func createSections(_ character: RMCharacter?) {
        guard let character = character else { return }

        let photoSection: RMCharacterSection = .photo(image: character.image)
        let informationSection: RMCharacterSection = .characterInfo(data: [
            (type: .status, value: character.status.rawValue),
            (type: .gender, value: character.gender.rawValue),
            (type: .type, value: character.type.isEmpty ? "N/A" : character.type),
            (type: .species, value: character.species),
            (type: .origin, value: character.origin.name),
            (type: .location, value: character.location.name),
            (type: .created, value: character.created),
            (type: .episodeCount, value: "\(character.episode.count)")
        ])
        
        sections = [photoSection, informationSection]
    }

    private func appendEpisodesToSections(_ episodes: [RMEpisode]?) {
        guard let episodes = episodes else { return }
        sections.append(.episode(episode: episodes))
        loadingView.hide()
        detailView.configure(with: sections)
    }
}

// MARK: - UICollectionViewDataSource

extension RMCharacterDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .photo:
            return 1
        case .characterInfo(let data):
            return data.count
        case .episode(let episodes):
            return episodes.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        
        switch section {
        case .photo(let image):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIdentifer, for: indexPath) as? RMCharacterPhotoCollectionViewCell else {
                fatalError("Failed to dequeue RMCharacterPhotoCollectionViewCell")
            }
            cell.configure(with: image)
            return cell
            
        case .characterInfo(let data):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifer, for: indexPath) as? RMCharacterInfoCollectionViewCell else {
                fatalError("Failed to dequeue RMCharacterInfoCollectionViewCell")
            }
            let info = data[indexPath.row]
            cell.configure(with: info.type, value: info.value)
            return cell
            
        case .episode(let episodes):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifer, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
                fatalError("Failed to dequeue RMCharacterEpisodeCollectionViewCell")
            }
            let episode = episodes[indexPath.row]
            cell.configure(with: episode)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension RMCharacterDetailViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section {
        case .photo, .characterInfo:
            break
        case .episode(let episodes):
            let selectedEpisode = episodes[indexPath.row]
            print(selectedEpisode)

            let vc = RMEpisodeDetailViewController(episode: selectedEpisode as! RMEpisode)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

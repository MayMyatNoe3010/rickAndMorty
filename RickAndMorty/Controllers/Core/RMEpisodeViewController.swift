//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by User on 23/02/2025.
//

import UIKit
import Combine
/// Contoller to show and search episodes
protocol RMEpisodeListDelegate: AnyObject{
    func didSelectEpisode(_ episode: RMEpisode)
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes()
}
final class RMEpisodeViewController: BaseViewController, RMEpisodeListDelegate, RMEpisodeListViewDelegate {
    
        
    private let viewModel = RMEpisodeViewModel()
    private let loadingView = LoadingView()
    private let listView = RMEpisodeListView()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Episodes"
        setupUI()
        observeViewModel()
        didLoadInitialEpisodes()
    }
    private func setupUI(){
        listView.delegate = self
        listView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViews(listView, loadingView)
        NSLayoutConstraint.activate([
            listView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            listView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        loadingView.hide()
    }
    
    private func observeViewModel(){
        viewModel.$allEpisodes
            .receive(on: DispatchQueue.main)
            .sink{[weak self] state in
                self?.handleState(state)
                
            }
            .store(in: &cancellables)
    }
    
    private func handleState(_ state: RMDataWrapper<[RMEpisode]?>){
       
        switch state.state{
            
        case .loading(_):
            loadingView.show()
            break
        case .success:
            loadingView.hide()
            listView.updateEpisode((state.data ?? []) ?? [])
            listView.updateShouldLoadMore(viewModel.isLoadMore)
            break
        case .noData(_):
            loadingView.hide()
            break
            
        case .error(_):
            loadingView.hide()
            break
        default: break
        }

    }
    //RMEpisodeListDelegate
    func didSelectEpisode(_ episode: RMEpisode) {
        let detailVC = RMEpisodeDetailViewController(episode: episode)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)

    }
    
    func didLoadInitialEpisodes() {
        viewModel.getInitialEpisodes()
    }
    
    func didLoadMoreEpisodes() {
        viewModel.getMoreEpisodes()
    }
    
    //RMEpisodeListViewDelegate
    func didSelectEpisode(_ episodeListView: RMEpisodeListView, selectedEpisode episode: RMEpisode) {
        didSelectEpisode(episode)
    }
    
    func didScroll(_ scrollView: UIScrollView) {
        handleScrollView(scrollView: scrollView){
            didLoadMoreEpisodes()
        }
    }


}

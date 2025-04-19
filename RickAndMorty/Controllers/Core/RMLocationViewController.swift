//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by User on 23/02/2025.
//

import UIKit
import Combine
/// Contoller to show and search locations
protocol RMLocationListDelegate: AnyObject{
    func didSelectLocation(_ location: RMLocation)
    func didLoadInitialData()
    func didLoadMoreData()
}
final class RMLocationViewController: UIViewController, RMLocationListDelegate, RMLocationListViewDelegate {
    private let viewModel = RMLocationViewModel()
    private let loadingView = LoadingView()
    private let listView = RMLocationListView()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Locations"
        setupUI()
        observeViewModel()
        didLoadInitialData()
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
        viewModel.$allLocations.receive(on: DispatchQueue.main)
            .sink{[weak self] state in
                self?.handleState(state)
                
            }
            .store(in: &cancellables)
    }
    
    private func handleState(_ state: RMDataWrapper<[RMLocation]?>){
        print("State----:\(state)")
        switch state.state{
            
        case .loading(_):
            loadingView.show()
            break
        case .success:
            loadingView.hide()
            
            listView.updateLocations((state.data ?? []) ?? [])
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

    
    //RMLocationListDelegate
    func didSelectLocation(_ location: RMLocation) {
        let detailVC = RMLocationDetailViewController(location: location)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)

    }
    
    func didLoadInitialData() {
        viewModel.getInitialLocations()
    }
    
    func didLoadMoreData() {
        viewModel.getMoreLocations()
    }
    
    //RMLocationListViewDelegate
    func didSelectEpisode(_ locationListView: RMLocationListView, selectedLocation location: RMLocation) {
        didSelectLocation(location)
    }
    
    func didScroll(_ scrollView: UIScrollView) {
        didLoadMoreData()
    }
}

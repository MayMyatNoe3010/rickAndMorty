//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by User on 23/02/2025.
//

import UIKit
import Combine

protocol RMCharacterListDelegate: AnyObject {
    func didSelectCharacter(_ character: RMCharacter)
    func didLoadInitialCharacters()
    func didLoadMoreCharacters()
}


/// Contoller to show and search characters
final class RMCharacterViewController: BaseViewController, RMCharacterListDelegate, RMCharacterListViewDelegate {
    
    
    
    private let viewModel = RMCharacterViewModel()
    private let loadingView = LoadingView()
    private let characterListView = RMCharacterListView()
    private var cancellables = Set<AnyCancellable>()
    private var isCurrentLoadMore = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        setupUI()
        bindViewModel()
        didLoadInitialCharacters()
    }
    private func setupUI(){
        characterListView.delegate = self
        characterListView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubViews(characterListView, loadingView)
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            characterListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        loadingView.hide()
    }
    private func bindViewModel(){
        viewModel.$allCharacters
            .receive(on: DispatchQueue.main)
            .sink{[weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleState(_ state: RMDataWrapper<[RMCharacter]?>){
        print("State: \(state.state)")
        switch state.state{
            
        case .loading(_):
            loadingView.show()
            break
        case .success:
            loadingView.hide()
            characterListView.updateCharacters((state.data ?? []) ?? [])
            characterListView.updateShouldLoadMore(viewModel.isLoadMore)
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
    
    //RMCharacterListViewDelegate
    func didSelectCharacter(_ characterListView: RMCharacterListView, selectedCharacter character: RMCharacter) {
        didSelectCharacter(character)
    }
    func didScroll(_ scrollView: UIScrollView) {
        handleScrollView(scrollView: scrollView){
            didLoadMoreCharacters()
        }
    }
    //RMCharacterListDelegate
    func didSelectCharacter(_ character: RMCharacter) {
        let detailVC = RMCharacterDetailViewController(character: character, viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    func didLoadInitialCharacters() {
        viewModel.getInitialCharacters()
    }
    
    func didLoadMoreCharacters() {
        viewModel.getMoreCharacters()
    }
    
}

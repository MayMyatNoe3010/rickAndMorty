//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by User on 23/02/2025.
//

import UIKit
import Combine

protocol RMCharacterListDelegate: AnyObject {
    func initialAPICall()
    func loadMoreCharacters()
}


/// Contoller to show and search characters
final class RMCharacterViewController: UIViewController, RMCharacterListDelegate {
    

    private let viewModel = RMViewModel()
    private let loadingView = LoadingView()
    private let characterListView = RMCharacterListView()
    private var cancellables = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        setupUI()
        bindViewModel()
    }
    private func setupUI(){
        
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
    
    private func handleState(_ state: RMDataWrapper<[RMCharacter]>){
        print("State: \(state.state)")
        switch state.state{

        case .loading(_):
            loadingView.show()
            break
        case .success:
            loadingView.hide()
            characterListView.updateCharacters(state.data ?? [])
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
    
    func initialAPICall() {
        viewModel.getAllCharacters()
    }
    
    func loadMoreCharacters() {
        
    }

  
}

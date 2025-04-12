//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by User on 10/04/2025.
//

import Foundation
import UIKit
import Combine

final class RMEpisodeDetailViewController : UIViewController{
    private let episode: RMEpisode
    private let detailView: RMEpisodeDetailView
    private var cancellables = Set<AnyCancellable>()
    
    init(episode: RMEpisode){
        self.episode = episode
        self.detailView = RMEpisodeDetailView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        setupUI()
        
    }
    private func setupUI(){
        detailView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(detailView)
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
}

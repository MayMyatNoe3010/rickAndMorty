//
//  LoadingView.swift
//  RickAndMorty
//
//  Created by User on 26/02/2025.
//

import UIKit
final class LoadingView : UIView{
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true

        return indicator
    }()
    override init(frame: CGRect){
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setUpUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(){
        isHidden = false
        indicator.startAnimating()
    }
    func hide(){
        isHidden = true
        indicator.stopAnimating()
    }
    private func setUpUI(){
        backgroundColor = .systemRed
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addConstraints()
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            indicator.widthAnchor.constraint(equalToConstant: 100),
            indicator.heightAnchor.constraint(equalToConstant: 100),
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

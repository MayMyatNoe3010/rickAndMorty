//
//  RMCharacterItemCell.swift
//  RickAndMorty
//
//  Created by User on 26/02/2025.
//

import UIKit
import Kingfisher
final class RMCharacterItemCell: UICollectionViewCell{
    static let cellIdentifier = "RMCharacterItemCell"
    var character: RMCharacterDataRender?
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
            let label = UILabel()
            label.textColor = .secondaryLabel
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubViews(imageView, nameLabel, statusLabel)
        addConstraints()
        setUpLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(with character: RMCharacterDataRender){
        nameLabel.text = character.name
        statusLabel.text = character.status.rawValue
        if let imageURL = URL(string: character.image){
            loadImage(imageURL)
        }
    }
    private func loadImage(_ url: URL){
        self.imageView.kf.setImage(
            with: url,
            options: [
                .processor(RoundCornerImageProcessor(cornerRadius: 20)), // Rounded corners
                .transition(.fade(0.2)), // Smooth fade-in effect
                .cacheOriginalImage // Ensures caching works properly
            ]
        )
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            statusLabel.heightAnchor.constraint(equalToConstant: 30),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            statusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor),


            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -4)
            
        ])
    }
    
    private func setUpLayer(){
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.cornerRadius = 4
        contentView.layer.shadowOffset = CGSize(width: -4, height: -4)
        //contentView.layer.opacity = 0.3
    }
    
    //useful for responding to changes in dark mode, dynamic text sizes, device rotation, and other UI environment changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
    }
    
}

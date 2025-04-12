//
//  RMCharacterInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by User on 20/03/2025.
//

import UIKit

class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifer = "RMCharacterInfoCollectionViewCell"
    
    private let lbValue: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .light)
        return label
    }()
    
    private let lbTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    private let titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubViews(titleContainerView, lbValue, iconImageView)
        titleContainerView.addSubview(lbTitle)
        setUpConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            lbValue.text = nil
            lbTitle.text = nil
            iconImageView.image = nil
            iconImageView.tintColor = .label
            lbTitle.textColor = .label
        }
    
    public func configure(with type: RMType, value: String){
        lbTitle.text = type.displayTitle
        lbValue.text = value
        iconImageView.image = type.iconImage
        iconImageView.tintColor = type.tintColor
        lbTitle.textColor = type.tintColor
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            titleContainerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleContainerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titleContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33),

            lbTitle.leftAnchor.constraint(equalTo: titleContainerView.leftAnchor),
            lbTitle.rightAnchor.constraint(equalTo: titleContainerView.rightAnchor),
            lbTitle.topAnchor.constraint(equalTo: titleContainerView.topAnchor),
            lbTitle.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor),

            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),
            iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),

            lbValue.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10),
            lbValue.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            lbValue.topAnchor.constraint(equalTo: contentView.topAnchor),
            lbValue.bottomAnchor.constraint(equalTo: titleContainerView.topAnchor)
        ])
    }

}

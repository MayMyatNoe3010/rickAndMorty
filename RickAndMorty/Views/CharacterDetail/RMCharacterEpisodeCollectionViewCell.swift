//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by User on 20/03/2025.
//

import UIKit

class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let cellIdentifer = "RMCharacterEpisodeCollectionViewCell"
    private let lbSeason: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    private let lbName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    private let lbAirDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.addSubViews(lbSeason, lbName, lbAirDate)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lbSeason.text = nil
        lbName.text = nil
        lbAirDate.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: RMEpisodeDataRender){
        lbName.text = data.name
        lbSeason.text = "Episode: "+data.episode
        lbAirDate.text = "Aired Date: "+data.air_date
    }
    
    private func setupUI(){
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
        NSLayoutConstraint.activate([
            lbSeason.topAnchor.constraint(equalTo: contentView.topAnchor),
            lbSeason.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            lbSeason.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            lbSeason.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            
            lbName.topAnchor.constraint(equalTo: lbSeason.bottomAnchor),
            lbName.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            lbName.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            lbName.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            
            lbAirDate.topAnchor.constraint(equalTo: lbName.bottomAnchor),
            lbAirDate.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            lbAirDate.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            lbAirDate.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
        ])
    }
}

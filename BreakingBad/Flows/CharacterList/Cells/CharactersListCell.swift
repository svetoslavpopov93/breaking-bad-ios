//
//  CharactersListCell.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 4.03.21.
//

import UIKit
import SDWebImage

class CharactersListCell: UITableViewCell {
    private let mainStackView: UIStackView
    private let thumbnailImage: UIImageView
    private let nameLabel: UILabel
    private let nicknameLabel: UILabel
    
    private var resultHandler: ((Bool) -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        mainStackView = UIStackView()
        thumbnailImage = UIImageView()
        nameLabel = UILabel()
        nicknameLabel = UILabel()
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        mainStackView = UIStackView()
        thumbnailImage = UIImageView()
        nameLabel = UILabel()
        nicknameLabel = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    private func commonInit() {
        contentView.backgroundColor = ColorPalette.backgroundColor
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.addArrangedSubview(thumbnailImage)
        mainStackView.alignment = .center
        mainStackView.axis = .horizontal
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 10)
        mainStackView.spacing = 8
        mainStackView.backgroundColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
        
        let labelsStackView = UIStackView(arrangedSubviews: [nameLabel, nicknameLabel])
        labelsStackView.axis = .vertical
        
        mainStackView.addArrangedSubview(labelsStackView)
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            thumbnailImage.heightAnchor.constraint(equalTo: thumbnailImage.widthAnchor),
            thumbnailImage.heightAnchor.constraint(equalToConstant: 66),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            nameLabel.heightAnchor.constraint(equalTo: nicknameLabel.heightAnchor)
        ])
    }
    
    func configure(with imageUrl: String?, name: String?, nickname: String?) {
        nameLabel.text = name
        nameLabel.textColor = ColorPalette.activeColor
        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        if let nickname = nickname {
            nicknameLabel.text = "\"\(nickname)\""
            nicknameLabel.textColor = ColorPalette.activeColor
            nicknameLabel.font = .systemFont(ofSize: 12, weight: .regular)
        }
        
        thumbnailImage.contentMode = .scaleAspectFill
        thumbnailImage.sd_setImage(with: URL(string: imageUrl ?? ""),
                                   placeholderImage: UIImage(systemName: "person.fill"),
                                   options: .continueInBackground,
                                   context: [:])
        mainStackView.layer.cornerRadius = 20
        thumbnailImage.clipsToBounds = true
        thumbnailImage.layer.cornerRadius = 16
    }
    
}

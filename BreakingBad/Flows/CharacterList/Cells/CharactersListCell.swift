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
    private let label: UILabel
    
    private var resultHandler: ((Bool) -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        mainStackView = UIStackView()
        thumbnailImage = UIImageView()
        label = UILabel()
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        mainStackView = UIStackView()
        thumbnailImage = UIImageView()
        label = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    private func commonInit() {
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.addArrangedSubview(thumbnailImage)
        mainStackView.addArrangedSubview(label)
        mainStackView.axis = .horizontal
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 10)
        mainStackView.spacing = 8
        mainStackView.backgroundColor = .green
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            thumbnailImage.heightAnchor.constraint(equalTo: thumbnailImage.widthAnchor),
            thumbnailImage.heightAnchor.constraint(equalToConstant: 66),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
        ])
    }
    
    func configure(with imageUrl: String?, name: String?) {
        label.text = name
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

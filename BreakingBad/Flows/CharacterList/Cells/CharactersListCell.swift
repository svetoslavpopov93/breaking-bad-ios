//
//  CharactersListCell.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 4.03.21.
//

import UIKit

class CharactersListCell: UITableViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func prepareForReuse() {
        thumbnailImageView.image = nil
    }
    
    func configure(with imageURL: String?, name: String?) {
        nameLabel.text = name
        containerView.layer.cornerRadius = 16
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.layer.cornerRadius = 10
        thumbnailImageView.downloadFromURL(imageURL ?? "", failureBlock: { [weak self] in
                self?.thumbnailImageView.image = UIImage(systemName: "person.fill.xmark")?.withRenderingMode(.alwaysTemplate)
                self?.thumbnailImageView.tintColor = .red
        })
    }
}

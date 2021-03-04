//
//  UserListCell.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 4.03.21.
//

import UIKit

class UserListCell: UITableViewCell {
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    func configure(with imageURL: String?, name: String?) {
        thumbnailImageView.image = UIImage(named: "person.crop.circle")
        thumbnailImageView.downloadFromURL(imageURL ?? "", completionBlock: { [weak self] result in
            switch result {
            case .success(let image):
                self?.thumbnailImageView.image = image
            case .failure:
                self?.thumbnailImageView.image = UIImage(named: "person.crop.circle.fill.badge.xmark")
            }
        })
    }
}

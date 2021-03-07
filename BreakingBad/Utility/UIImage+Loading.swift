//
//  UIImage+Loading.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 4.03.21.
//

import UIKit

extension UIImageView {
    func downloadFromURL(_ urlString: String, failureBlock: @escaping () -> Void) {
        guard let url = URL(string: urlString) else {
            failureBlock()
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let imageData = data, let image = UIImage(data: imageData) else {
                    failureBlock()
                    return
                }
                self?.image = image
                self?.contentMode = .scaleAspectFill
            }
        }).resume()
    }
}

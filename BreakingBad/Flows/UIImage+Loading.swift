//
//  UIImage+Loading.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 4.03.21.
//

import UIKit

extension UIImageView {
    func downloadFromURL(_ urlString: String, completionBlock: @escaping (Result<UIImage, ImageDownloadError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completionBlock(.failure(.downloadFailure))
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard let imageData = data,
                      let image = UIImage(data: imageData),
                      error != nil else {
                    completionBlock(.failure(.downloadFailure))
                    return
                }
                completionBlock(.success(image))
            }
        })
    }
}

enum ImageDownloadError: Error {
    case downloadFailure
}

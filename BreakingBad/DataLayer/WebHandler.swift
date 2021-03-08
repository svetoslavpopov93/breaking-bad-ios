//
//  WebHandler.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 9.03.21.
//

import Foundation

protocol WebHandlerProtocol {
    func fetchCharacters(completionHandler: @escaping (Result<Data, Error>) -> Void)
}

class WebHandler: WebHandlerProtocol {
    func fetchCharacters(completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "https://breakingbadapi.com/api/characters") else {
            return
        }
    
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
            }
            
            if let data = data {
                completionHandler(.success(data))
            } else {
                completionHandler(.failure(BreakingBadError.invalidResponse))
            }
        }
        task.resume()
    }
}

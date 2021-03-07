//
//  CharactersListInteractor.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 3.03.21.
//

import CoreData

protocol CharactersListInteractorInput: class {
    func viewLoaded()
}

protocol CharactersListInteractorOutput: class {
    func didUpdateCharacters(_ characters: [Character])
    func didFailToUpdateCharacters()
}

enum BreakingBadError: Error {
    case downloadFailure
}

class CharactersListInteractor: NSObject, CharactersListInteractorInput {
    let presenter: CharactersListInteractorOutput
    
    init(presenter: CharactersListInteractorOutput) {
        self.presenter = presenter
        super.init()
    }
    
    func viewLoaded() {
        guard let url = URL(string: "https://breakingbadapi.com/api/characters") else {
            return
        }
    
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            if let data = data,
               let characters = try? JSONDecoder().decode([Character].self, from: data) {
                self?.presenter.didUpdateCharacters(characters)
            } else {
                self?.presenter.didFailToUpdateCharacters()
            }
        }
        task.resume()
    }
}

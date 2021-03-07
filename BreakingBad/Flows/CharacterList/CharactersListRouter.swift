//
//  CharactersListRouter.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 3.03.21.
//

import UIKit

protocol CharactersListRouterInput: class {
    func showUpdateFailureError()
    func showDetails(for character: Character)
}

class CharactersListRouter: CharactersListRouterInput {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showUpdateFailureError() {
        let alert = UIAlertController(title: "Something went wrong", message: "Unable to fetch characters list...", preferredStyle: .alert)
        alert.addAction(.init(title: "Dismiss", style: .cancel, handler: nil))
        navigationController.present(alert, animated: true, completion: nil)
    }
    
    func showDetails(for character: Character) {
        let previewViewController = CharacterPreviewViewController(character: character)
        navigationController.present(previewViewController, animated: true, completion: nil)
    }
}

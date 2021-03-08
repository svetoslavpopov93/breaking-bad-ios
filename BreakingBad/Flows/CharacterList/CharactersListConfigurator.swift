//
//  CharactersListConfigurator.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 4.03.21.
//

import Foundation
import UIKit

class CharactersListConfigurator {
    static func configure(with navigationController: UINavigationController, coreDataManager: CoreDataManagerProtocol) -> UIViewController {
        let router = CharactersListRouter(navigationController: navigationController)
        let presenter = CharactersListPresenter()
        let interactor = CharactersListInteractor(presenter: presenter, coreDataManager: coreDataManager, webHandler: WebHandler())
        let viewController = CharactersListViewController(interactor: interactor, router: router)
        presenter.view = viewController
        return viewController
    }
}

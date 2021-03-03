//
//  UserListConfigurator.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 4.03.21.
//

import Foundation
import UIKit

class UserListConfigurator {
    static func configure(navigationController: UINavigationController, coreDataManager: CoreDataManager) -> UIViewController {
        let router = UserListRouter(navigationController: navigationController)
        let presenter = UserListPresenter()
        let interactor = UserListInteractor(presenter: presenter, coreDataManager: coreDataManager)
        let viewController = UserListViewController(interactor: interactor, router: router)
        presenter.view = viewController
        return viewController
    }
}

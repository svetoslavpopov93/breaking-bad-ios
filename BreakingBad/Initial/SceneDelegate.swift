//
//  SceneDelegate.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 3.03.21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var navigationController = UINavigationController()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let viewController = CharactersListConfigurator.configure(navigationController: navigationController)
        navigationController.viewControllers = [viewController]
        window = UIWindow()

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}


//
//  CharactersListConfiguratorTests.swift
//  BreakingBadTests
//
//  Created by Svetoslav Popov on 9.03.21.
//

import XCTest
@testable import BreakingBad

class CharactersListConfiguratorTests: XCTestCase {
    func testConfigure() {
        let viewController = CharactersListConfigurator.configure(with: UINavigationController(), coreDataManager: CoreDataManager()) as? CharactersListViewController
        let interactor = viewController?.interactor as? CharactersListInteractor
        let presenter = interactor?.presenter as? CharactersListPresenter
        let router = viewController?.router as? CharactersListRouter
        
        XCTAssertNotNil(viewController)
        XCTAssertNotNil(interactor)
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(router)
    }
}

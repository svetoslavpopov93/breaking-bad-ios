//
//  CharactersListPresenterTests.swift
//  BreakingBadTests
//
//  Created by Svetoslav Popov on 9.03.21.
//

import XCTest
@testable import BreakingBad
import CoreData

class CharactersListPresenterTests: XCTestCase {
    var presenter: CharactersListPresenter!
    var viewController: MockViewController!
    
    override func setUp() {
        viewController = MockViewController()
        presenter = CharactersListPresenter()
        presenter.view = viewController
    }
    
    func testUpdate() {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let character = Character(context: context)
        let expectedName = UUID().uuidString
        character.name = expectedName
        
        viewController.updateHandler = { characters in
            XCTAssertEqual(characters.count, 1)
            XCTAssertEqual(characters.first?.name, expectedName)
        }
        presenter.didLoadCharacters([character])
        XCTAssertEqual(viewController.updateCallCount, 1)
    }
    
    func testShowUpdateFailure() {
        presenter.didFailToUpdateCharacters()
        XCTAssertEqual(viewController.showUpdateFailureCallCount, 1)
    }
    
    class MockViewController: CharactersListViewInput {
        var updateCallCount = 0
        var updateHandler: (([Character]) -> Void)?
        func update(with characters: [Character]) {
            updateCallCount += 1
            if let handler = updateHandler {
                handler(characters)
            }
        }
        
        var showUpdateFailureCallCount = 0
        func showUpdateFailure() {
            showUpdateFailureCallCount += 1
        }
    }
}

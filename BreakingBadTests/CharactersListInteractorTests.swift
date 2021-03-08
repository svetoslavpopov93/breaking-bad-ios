//
//  CharactersListInteractorTests.swift
//  BreakingBadTests
//
//  Created by Svetoslav Popov on 9.03.21.
//

import XCTest
@testable import BreakingBad
import CoreData

class CharactersListInteractorTests: XCTestCase {
    var interactor: CharactersListInteractor!
    var presenter: MockPresenter!
    var coreDataManager: MockCoreDataManager!
    var webHandler: MockWebHandler!
    
    override func setUp() {
        presenter = MockPresenter()
        webHandler = MockWebHandler()
        coreDataManager = MockCoreDataManager()
        interactor = CharactersListInteractor(presenter: presenter,
                                              coreDataManager: coreDataManager,
                                              webHandler: webHandler)
    }
    
    func testViewLoaded() {
        interactor.viewLoaded(with: SortAndFilterOptions.getStub())
        XCTAssertEqual(webHandler.fetchCharactersCallCount, 1)
    }
    
    func testHandleJSONWithCorrectData() {
        let jsonData = """
        [
          {
            "char_id": 1,
            "name": "Walter White",
            "birthday": "09-07-1958",
            "occupation": [
              "High School Chemistry Teacher",
              "Meth King Pin"
            ],
            "img": "https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg.jpg",
            "status": "Presumed dead",
            "nickname": "Heisenberg",
            "appearance": [
              1
            ],
            "portrayed": "Bryan Cranston",
            "category": "Breaking Bad",
            "better_call_saul_appearance": [
              
            ]
          }
        ]
        """.data(using: .utf8)
        webHandler.fetchResult = .success(jsonData!)
        
        coreDataManager.findHandler = { predicate in
            XCTAssertEqual(predicate.predicateFormat, "number == 1")
            return []
        }
        
        interactor.viewLoaded(with: SortAndFilterOptions.getStub())
        XCTAssertEqual(webHandler.fetchCharactersCallCount, 1)
        XCTAssertEqual(coreDataManager.findCallCount, 1)
        // Called twice- once for insert of season and once for the character
        XCTAssertEqual(coreDataManager.insertCallCount, 2)
    }
    
    func testApplyOptionCall() {
        interactor.applyOptions(SortAndFilterOptions.getStub(), searchQuery: nil)
        XCTAssertEqual(presenter.didLoadCharactersCallCount, 1)
    }
    
    class MockPresenter: CharactersListInteractorOutput {
        var didLoadCharactersCallCount = 0
        var didLoadCharactersHandler: (([Character]) -> Void)?
        func didLoadCharacters(_ characters: [Character]) {
            didLoadCharactersCallCount += 1
            if let handler = didLoadCharactersHandler {
                handler(characters)
            }
        }
        
        var didFailToUpdateCharactersCallCount = 0
        func didFailToUpdateCharacters() {
            didFailToUpdateCharactersCallCount += 1
        }
    }
    
    class MockWebHandler: WebHandlerProtocol {
        var fetchCharactersCallCount = 0
        var fetchResult: Result<Data, Error>?
        func fetchCharacters(completionHandler: @escaping (Result<Data, Error>) -> Void) {
            fetchCharactersCallCount += 1
            if let fetchResult = fetchResult {
                completionHandler(fetchResult)
            }
        }
    }
    
    class MockCoreDataManager: CoreDataManagerProtocol {
        var fetchedResultsControllerCallCount = 0
        var fetchedResultsControllerHandler: (([NSSortDescriptor]) -> Void)?
        func fetchedResultsController<T>(with sortDescriptors: [NSSortDescriptor]) -> NSFetchedResultsController<T> where T : NSManagedObject {
            fetchedResultsControllerCallCount += 1
            if let handler = fetchedResultsControllerHandler {
                handler(sortDescriptors)
            }
            return NSFetchedResultsController()
        }
        
        var context: NSManagedObjectContext {
            return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        }
        
        var insertCallCount = 0
        func insert<T>(setupBlock: ((T) -> Void)) -> T where T : NSManagedObject {
            insertCallCount += 1
            return T(context: context)
        }
        
        var checkIfExistsCallCount = 0
        var checkIfExitstsHandler: ((NSPredicate) -> Bool)?
        func checkIfExists<T>(of type: T.Type, predicate: NSPredicate) -> Bool where T : NSManagedObject {
            checkIfExistsCallCount += 1
            if let handler = checkIfExitstsHandler {
                return handler(predicate)
            } else {
                return false
            }
        }
        
        var findCallCount = 0
        var findHandler: ((NSPredicate) -> [NSManagedObject])?
        func find<T>(with predicate: NSPredicate) -> [T]? where T : NSManagedObject {
            findCallCount += 1
            if let handler = findHandler {
                let objects: [T]? = handler(predicate) as? [T]
                return objects
            } else {
                return nil
            }
        }
        
        var saveContextCallCount = 0
        func saveContext() {
            saveContextCallCount += 1
        }
    }
}

extension SortAndFilterOptions {
    static func getStub(sortCriteria: String = "",
                        isAscending: Bool = true,
                        seasonsOptions: [SeasonFilterOption] = [],
                        statusOptions: [FilterOption] = []) -> SortAndFilterOptions {
        return SortAndFilterOptions(sortCriteria: sortCriteria,
                                    isAscending: isAscending,
                                    seasonsOptions: seasonsOptions,
                                    statusOptions: statusOptions)
    }
}

//
//  UserListInteractor.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 3.03.21.
//

import Foundation

protocol UserListInteractorInput: class {
    
}

protocol UserListInteractorOutput: class {
    
}

class UserListInteractor: UserListInteractorInput {
    var presenter: UserListInteractorOutput
    var coreDataManager: CoreDataManager
    
    init(presenter: UserListInteractorOutput,
         coreDataManager: CoreDataManager) {
        self.presenter = presenter
        self.coreDataManager = coreDataManager
    }
}

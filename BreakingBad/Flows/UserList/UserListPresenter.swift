//
//  UserListPresenter.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 3.03.21.
//

import CoreData

class UserListPresenter: UserListInteractorOutput {
    weak var view: UserListViewInput?
    
    func didUpdateProfiles(_ profiles: [Profile]) {
        view?.update(with: profiles)
    }
}

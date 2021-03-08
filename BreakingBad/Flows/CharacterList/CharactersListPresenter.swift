//
//  CharactersListPresenter.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 3.03.21.
//

import CoreData

class CharactersListPresenter: CharactersListInteractorOutput {
    weak var view: CharactersListViewInput?
    
    func didLoadCharacters(_ characters: [Character]) {
        view?.update(with: characters)
    }
    
    func didFailToUpdateCharacters() {
        
    }
}

//
//  UserListInteractor.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 3.03.21.
//

import CoreData

protocol UserListInteractorInput: class {
    func fetchData()
}

protocol UserListInteractorOutput: class {
    func didUpdateProfiles(_ profiles: [Profile])
}

class UserListInteractor: NSObject, UserListInteractorInput {
    let presenter: UserListInteractorOutput
    let coreDataManager: CoreDataManager
    let fetchedResultsController: NSFetchedResultsController<Profile>
    
    init(presenter: UserListInteractorOutput,
         coreDataManager: CoreDataManager) {
        self.presenter = presenter
        self.coreDataManager = coreDataManager
        let request = NSFetchRequest<Profile>(entityName: "Profile")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: coreDataManager.context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
    }
    
    func fetchData() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Unable to fetch the profiles... Error: \(error.localizedDescription)")
        }
    }
}

extension UserListInteractor: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let profiles: [Profile] = controller.fetchedObjects?.compactMap({ $0 as? Profile }) ?? []
        presenter.didUpdateProfiles(profiles)
    }
}

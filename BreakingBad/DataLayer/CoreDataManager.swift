//
//  CoreDataManager.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 4.03.21.
//

import CoreData

class CoreDataManager {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BreakingBad")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func insert<T: NSManagedObject>(setupBlock: ((T) -> Void)) -> T {
        let object = T(context: persistentContainer.viewContext)
        setupBlock(object)
        return object
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

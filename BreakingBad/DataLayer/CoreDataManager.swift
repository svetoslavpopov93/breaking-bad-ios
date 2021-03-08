//
//  CoreDataManager.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 4.03.21.
//

import CoreData

class CoreDataManager {
    static let sharedInstance: CoreDataManager = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BreakingBad")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    @discardableResult
    func insert<T: NSManagedObject>(setupBlock: ((T) -> Void)) -> T {
        let object = T(context: persistentContainer.viewContext)
        setupBlock(object)
        persistentContainer.viewContext.insert(object)
        return object 
    }
    
    func checkIfExists<T: NSManagedObject>(of type: T.Type, predicate: NSPredicate) -> Bool {
        let results: [T]? = find(with: predicate)
        return (results?.count ?? 0) > 0
    }
    
    func find<T: NSManagedObject>(with predicate: NSPredicate) -> [T]? {
        let request = T.fetchRequest()
        request.predicate = predicate
        let results: [T]? = try? context.fetch(request) as? [T]
        return results
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

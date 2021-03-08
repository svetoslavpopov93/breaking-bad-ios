//
//  CharactersListInteractor.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 3.03.21.
//

import CoreData

protocol CharactersListInteractorInput: class {
    func viewLoaded(with options: SortAndFilterOptions)
    func applyOptions(_ options: SortAndFilterOptions, searchQuery: String?)
}

protocol CharactersListInteractorOutput: class {
    func didLoadCharacters(_ characters: [Character])
    func didFailToUpdateCharacters()
}

enum BreakingBadError: Error {
    case downloadFailure
}

class CharactersListInteractor: NSObject {
    let presenter: CharactersListInteractorOutput
    let coreDataManager = CoreDataManager.sharedInstance
    let fetchedResultsController: NSFetchedResultsController<Character>
    
    init(presenter: CharactersListInteractorOutput) {
        self.presenter = presenter
        let request = NSFetchRequest<Character>(entityName: "Character")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: coreDataManager.context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
    }
    
    private func fetchData() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Unable to fetch the profiles... Error: \(error.localizedDescription)")
        }
    }
}

// MARK: - CharactersListInteractorInput

extension CharactersListInteractor: CharactersListInteractorInput {
    func viewLoaded(with options: SortAndFilterOptions) {
        fetchData()
        
        guard let url = URL(string: "https://breakingbadapi.com/api/characters") else {
            return
        }
    
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            self?.handleJSON(data, response: response, error: error)
        }
        task.resume()
    }
    
    func applyOptions(_ options: SortAndFilterOptions, searchQuery: String?) {
        // Sorting
        fetchedResultsController.fetchRequest.sortDescriptors = [options.sortDescriptor]
        
        // Filter by season
        let filteredSeasonOptionss: [SeasonFilterOption] = options.seasonsOptions.filter({ $0.isSelected })
        let seasonPredicates: [NSPredicate] = filteredSeasonOptionss.compactMap({ [weak self] seasonOption in
            guard let strongSelf = self else { return nil }
            return strongSelf.getSeasonsPredicateFormat(for: seasonOption.number, isSelected: seasonOption.isSelected)
        })
    
        // Filter by status
        let filteredStatusOptions: [FilterOption] = options.statusOptions.filter({ $0.isSelected })
        let statusPredicates: [NSPredicate] = filteredStatusOptions.compactMap({ [weak self] statusOption in
            guard let strongSelf = self else { return nil }
            return strongSelf.getStatusPredicateFormat(for: statusOption.title, isSelected: statusOption.isSelected)
        })
        
        // Search
        let searchPredicates: [NSPredicate]
        if let query = searchQuery, query != "" {
            searchPredicates = [NSPredicate(format: "name CONTAINS[c] %@ OR nickname CONTAINS[c] %@", query, query)]
        } else {
            searchPredicates = []
        }
        
        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: seasonPredicates + statusPredicates + searchPredicates)
        fetchData()
        
        // Trigger table view update manually since only the sort descriptor was changed, not the content,
        // and the fetched results controller's delegate functions wont be triggred
        presenter.didLoadCharacters(fetchedResultsController.fetchedObjects ?? [])
    }
}

// MARK: - Utility

extension CharactersListInteractor {
    private func handleJSON(_ data: Data?, response: URLResponse?, error: Error?) {
        let coreDataManager = CoreDataManager.sharedInstance
        if let data = data,
           let jsonObjects = try? JSONSerialization.jsonObject(with: data,
                                                               options: JSONSerialization.ReadingOptions.allowFragments) as? [[AnyHashable: Any]] {
            for json in jsonObjects {
                if let imageUrl = json["img"] as? String,
                   let name = json["name"] as? String,
                   let nickname = json["nickname"] as? String,
                   let status = json["status"] as? String,
                   let occupation = json["occupation"] as? [String],
                   let seasonAppearances = json["appearance"] as? [Int] {
                    addCharactersToStorage(imageUrl: imageUrl,
                                           name: name,
                                           nickname: nickname,
                                           status: status,
                                           occupation: occupation,
                                           seasonAppearances: seasonAppearances,
                                           coredataManager: coreDataManager)
                } else {
                    assert(false, "Failed to parse data.")
                }
            }
            
            if coreDataManager.context.hasChanges {
                coreDataManager.saveContext()
            } else {
                presenter.didLoadCharacters(fetchedResultsController.fetchedObjects ?? [])
            }
        } else {
            presenter.didFailToUpdateCharacters()
        }
    }
    
    private func addCharactersToStorage(imageUrl: String,
                                        name: String,
                                        nickname: String,
                                        status: String,
                                        occupation: [String],
                                        seasonAppearances: [Int],
                                        coredataManager: CoreDataManager) {
        var appearances: [Season] = []
        for seasonNumber in seasonAppearances {
            if let season: Season = coreDataManager.find(with: NSPredicate(format: "number == %d", seasonNumber))?.first {
                appearances.append(season)
            } else {
                let setupBlock: ((Season) -> Void) = { season in
                    season.number = Int32(seasonNumber)
                    season.title = "Season \(seasonNumber)"
                }
                appearances.append(coreDataManager.insert(setupBlock: setupBlock))
            }
        }
        
        if !coreDataManager.checkIfExists(of: Character.self, predicate: NSPredicate(format: "name == %@", name)) {
            let setupBlock: ((Character) -> Void) = { character in
                character.imageUrl = imageUrl
                character.name = name
                character.nickname = nickname
                character.status = status
                character.occupation = occupation
                let appearancesSet = NSSet(array: appearances)
                character.addToSeasons(appearancesSet)
            }
            coreDataManager.insert(setupBlock: setupBlock)
        }
    }
    
    private func getSeasonsPredicateFormat(for season: Int, isSelected: Bool) -> NSPredicate {
        let selectedFormat = isSelected ? "==" : "!="
        return NSPredicate(format: "ANY seasons.number \(selectedFormat) %d", season)
    }
    
    private func getStatusPredicateFormat(for status: String, isSelected: Bool) -> NSPredicate {
        let selectedFormat = isSelected ? "==" : "!="
        return NSPredicate(format: "status \(selectedFormat) %@", status)
    }

}

// MARK: - NSFetchedResultsControllerDelegate

extension CharactersListInteractor: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let characters: [Character] = controller.fetchedObjects?.compactMap({ $0 as? Character }) ?? []
        presenter.didLoadCharacters(characters)
    }
}

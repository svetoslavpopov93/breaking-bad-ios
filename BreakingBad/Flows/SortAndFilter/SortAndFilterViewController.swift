//
//  SortAndFilterViewController.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 7.03.21.
//

import UIKit

protocol FilterOption {
    var title: String { get }
    var isSelected: Bool { get set }
}

struct StatusFilterOption: FilterOption {
    let title: String
    var isSelected: Bool
}

struct SeasonFilterOption: FilterOption {
    let number: Int
    let title: String
    var isSelected: Bool
}

struct SortAndFilterOptions {
    var sortCriteria: String
    var isAscending: Bool
    var seasonsOptions: [SeasonFilterOption]
    var statusOptions: [FilterOption]
    
    var sortDescriptor: NSSortDescriptor {
        NSSortDescriptor(key: sortCriteria, ascending: isAscending)
    }
}

class SortAndFilterViewController: UIViewController {
    private enum Constants {
        static let criteria = ["name", "nickname"]
        static let ascending = ["ascending", "decsending"]
    }
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var seasons: [SeasonFilterOption]
    private var statuses: [FilterOption]
    private let resultsHandler: ((SortAndFilterOptions) -> Void)
    private var sortAndFilterOptions: SortAndFilterOptions
    
    private enum Section: Int, CaseIterable {
        case sort
        case filterBySeason
        case filterByStatus
    }
    
    private enum SortCell: Int, CaseIterable {
        case criteria
        case ascending
    }
    
    private enum FilterType {
        case season
        case status
    }
    
    init(seasons: [SeasonFilterOption],
         statuses: [FilterOption],
         sortAndFilterOptions: SortAndFilterOptions,
         resultsHandler: @escaping ((SortAndFilterOptions) -> Void)) {
        self.seasons = seasons
        self.statuses = statuses
        self.sortAndFilterOptions = sortAndFilterOptions
        self.resultsHandler = resultsHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    private func configureSubviews() {
        view.backgroundColor = ColorPalette.backgroundColor
        tableView.backgroundColor = ColorPalette.backgroundColor
        configureTableView()
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            view.topAnchor.constraint(equalTo: tableView.topAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
        ])
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SegmentedControlCell.self, forCellReuseIdentifier: "SegmentedControlCell")
        tableView.register(CheckboxCell.self, forCellReuseIdentifier: "CheckboxCell")
        tableView.register(LabelCell.self, forCellReuseIdentifier: "LabelCell")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SortAndFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            assert(false, "Unable to dequeue section.")
            return UITableViewCell()
        }
        
        let cell: UITableViewCell
        switch section {
        case .sort:
            cell = configuredSortCellAt(indexPath: indexPath)
        case .filterBySeason:
            cell = configuredFilterCellAt(indexPath: indexPath, type: .season)
        case .filterByStatus:
            cell = configuredFilterCellAt(indexPath: indexPath, type: .status)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = Section(rawValue: section) else {
            assert(false, "Section(\(section) out of bounds.")
            return 0
        }
        switch sectionType {
        case .sort:
            return SortCell.allCases.count
        case .filterBySeason:
            return seasons.count + 1 // Including the subsection title
        case .filterByStatus:
            return statuses.count + 1 // Including the subsection title
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionType = Section(rawValue: section) else {
            assert(false, "Section(\(section) out of bounds.")
            return nil
        }
        
        switch sectionType {
        case .sort:
            return "sort by"
        case .filterBySeason:
            return "filter by"
        case .filterByStatus:
            return nil
        }
    }
}

// MARK: - Utility

extension SortAndFilterViewController {
    private func configuredSortCellAt(indexPath: IndexPath) -> UITableViewCell {
        guard let sortCellType = SortCell(rawValue: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentedControlCell", for: indexPath) as? SegmentedControlCell else {
            assert(false, "Unable to dequeue cell at row: \(indexPath.row).")
            return UITableViewCell()
        }
        switch sortCellType {
        case .criteria:
            let index = Constants.criteria.firstIndex(of: sortAndFilterOptions.sortCriteria)
            let distance = Constants.criteria.distance(from: 0, to: index ?? .zero)
            cell.configure(with: Constants.criteria, selectedSegment: distance, resultsHandler: { [weak self] index in
                guard let strongSelf = self else { return }
                strongSelf.sortAndFilterOptions.sortCriteria = Constants.criteria[index]
                strongSelf.resultsHandler(strongSelf.sortAndFilterOptions)
            })
        case .ascending:
            cell.configure(with: Constants.ascending, selectedSegment: sortAndFilterOptions.isAscending ? 0 : 1, resultsHandler: { [weak self] index in
                guard let strongSelf = self else { return }
                strongSelf.sortAndFilterOptions.isAscending = index == 0
                strongSelf.resultsHandler(strongSelf.sortAndFilterOptions)
            })
        }
        return cell
    }
    
    private func configuredFilterCellAt(indexPath: IndexPath, type: FilterType) -> UITableViewCell {
        if indexPath.row == 0 {
            return configuredFilterSubheaderCell(at: indexPath, of: type)
        }
        
        switch type {
        case .season:
            let season = seasons[indexPath.row - 1]
            return configuredCheckboxCellAt(indexPath: indexPath, text: season.title, isSelected: season.isSelected, resultHandler: { [weak self] isSelected in
                guard let strongSelf = self else { return }
                strongSelf.seasons[indexPath.row - 1].isSelected = isSelected
                strongSelf.sortAndFilterOptions.seasonsOptions = strongSelf.seasons.filter({ $0.isSelected })
                strongSelf.resultsHandler(strongSelf.sortAndFilterOptions)
            })
        case .status:
            let status = statuses[indexPath.row - 1]
            return configuredCheckboxCellAt(indexPath: indexPath, text: status.title, isSelected: status.isSelected, resultHandler: { [weak self] isSelected in
                guard let strongSelf = self else { return }
                strongSelf.statuses[indexPath.row - 1].isSelected = isSelected
                strongSelf.sortAndFilterOptions.statusOptions = strongSelf.statuses.filter({ $0.isSelected })
                strongSelf.resultsHandler(strongSelf.sortAndFilterOptions)
            })
        }
    }
    
    private func configuredCheckboxCellAt(indexPath: IndexPath, text: String, isSelected: Bool, resultHandler: @escaping ((Bool) -> Void)) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "CheckboxCell", for: indexPath) as? CheckboxCell else {
            assert(false, "Unable to dequeue cell at row: \(indexPath.row).")
            return UITableViewCell()
        }
        cell.configure(with: text, isSelected: isSelected, resultHandler: resultHandler)
        return cell
    }

    private func configuredFilterSubheaderCell(at indexPath: IndexPath, of type: FilterType) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as? LabelCell else {
            assert(false, "Unable to dequeue cell at row: \(indexPath.row)")
            return UITableViewCell()
        }
        switch type {
        case .season:
            cell.configure(with: "season")
        case .status:
            cell.configure(with: "status")
        }
        return cell
    }
}

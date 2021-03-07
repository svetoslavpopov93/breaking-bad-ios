//
//  SortAndFilterViewController.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 7.03.21.
//

import UIKit

struct FilterOption {
    let title: String
    var isSelected: Bool
}

class SortAndFilterViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var seasons: [FilterOption]
    private var statuses: [FilterOption]
    
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
    
    init(seasons: [FilterOption], statuses: [FilterOption]) {
        self.seasons = seasons
        self.statuses = statuses
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
            return "Sort by"
        case .filterBySeason:
            return "Filter by"
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
            cell.configure(with: ["Name", "Nickname", "Season"], selectedSegment: UISegmentedControl.noSegment, resultsHandler: { index in
                print("Selected criteria at index: \(index)")
            })
        case .ascending:
            cell.configure(with: ["Ascending", "Decsending"], selectedSegment: UISegmentedControl.noSegment, resultsHandler: { index in
                print("Selected ascending at index: \(index)")
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
                self?.seasons[indexPath.row - 1].isSelected = isSelected
            })
        case .status:
            let status = statuses[indexPath.row - 1]
            return configuredCheckboxCellAt(indexPath: indexPath, text: status.title, isSelected: status.isSelected, resultHandler: { [weak self] isSelected in
                self?.statuses[indexPath.row - 1].isSelected = isSelected
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
            cell.configure(with: "Season")
        case .status:
            cell.configure(with: "Status")
        }
        return cell
    }
}

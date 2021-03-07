//
//  CharactersListViewController.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 3.03.21.
//

import UIKit

protocol CharactersListViewInput: class {
    func update(with characters: [Character])
    func showUpdateFailure()
}

class CharactersListViewController: UIViewController {
    private var seasons: [FilterOption] = [
        FilterOption(title: "1", isSelected: false),
        FilterOption(title: "2", isSelected: false),
        FilterOption(title: "3", isSelected: false),
        FilterOption(title: "4", isSelected: false),
        FilterOption(title: "5", isSelected: false)
    ]
    private var statuses: [FilterOption] = [
        FilterOption(title: "Alive", isSelected: false),
        FilterOption(title: "Presumed dead", isSelected: false),
        FilterOption(title: "Dead", isSelected: false),
        FilterOption(title: "Deceased", isSelected: false)
    ]
    
    
    
    
    var interactor: CharactersListInteractorInput
    var router: CharactersListRouterInput
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let blurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sortAndFilterContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var isSortAndFilterVissible: Bool = false {
        didSet {
            if isSortAndFilterVissible {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "line.horizontal.3.decrease.circle.fill")
                showSortAndFilter()
            } else {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "line.horizontal.3.decrease.circle")
                hideSortAndFilter()
            }
        }
    }
    
    private var tableViewLeadingConstraint: NSLayoutConstraint?
    private var sortAndFilterTrailingConstraint: NSLayoutConstraint?
    private var characters: [Character] = []
    
    init(interactor: CharactersListInteractorInput,
         router: CharactersListRouterInput) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubvies()
        
        activityIndicator.startAnimating()
        interactor.viewLoaded()
    }
}

// MARK: - Configuration

extension CharactersListViewController {
    private func configureSubvies() {
        view.backgroundColor = .white
        configureNavigationBar()
        configureTableView()
        configureSortAndFilterView()
        
        view.addSubview(activityIndicator)
        
        let tableViewLeadingConstraint = view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor)
        self.tableViewLeadingConstraint = tableViewLeadingConstraint
        let sortAndFilterTrailingConstraint = sortAndFilterContainer.leadingAnchor.constraint(equalTo: view.trailingAnchor)
        self.sortAndFilterTrailingConstraint = sortAndFilterTrailingConstraint
        
        NSLayoutConstraint.activate([
            // Table view
            tableViewLeadingConstraint,
            view.topAnchor.constraint(equalTo: tableView.topAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            
            // Activity indicator
            view.centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: activityIndicator.centerYAnchor),
            
            // Blur view
            
            view.topAnchor.constraint(equalTo: blurView.topAnchor),
            view.leadingAnchor.constraint(equalTo: blurView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: blurView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: blurView.bottomAnchor),
            
            // Sort and filter container
            sortAndFilterContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            sortAndFilterContainer.topAnchor.constraint(equalTo: view.topAnchor),
            sortAndFilterTrailingConstraint,
            sortAndFilterContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func configureNavigationBar() {
        title = "Characters"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "line.horizontal.3.decrease.circle"), primaryAction: UIAction(handler: { [weak self] _ in
            self?.toggleSortAndFilterView()
        }), menu: nil)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 84
        let nib = UINib(nibName: "CharactersListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CharactersListCell")
    }
    
    private func configureSortAndFilterView() {
        blurView.isHidden = true
        blurView.backgroundColor = .clear
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleSortAndFilterView))
        blurView.addGestureRecognizer(gestureRecognizer)
        
        view.addSubview(blurView)
        view.addSubview(sortAndFilterContainer)
        let sortAndFilterViewController = SortAndFilterViewController(seasons: seasons, statuses: statuses)
        add(sortAndFilterViewController, to: sortAndFilterContainer)
    }
}

// MARK: - Sort and Filter container management

extension CharactersListViewController {
    @objc private func toggleSortAndFilterView() {
        isSortAndFilterVissible.toggle()
    }
    
    private func showSortAndFilter() {
        let width = sortAndFilterContainer.frame.width
        tableViewLeadingConstraint?.constant = 16
        sortAndFilterTrailingConstraint?.constant = -width
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.blurView.isHidden = false
            self?.blurView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
            self?.view.layoutIfNeeded()
        })
    }
    
    private func hideSortAndFilter() {
        tableViewLeadingConstraint?.constant = 0
        sortAndFilterTrailingConstraint?.constant = 0
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.blurView.backgroundColor = .clear
            self?.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.blurView.isHidden = true
        })
    }
}

// MARK: - CharactersListViewInput

extension CharactersListViewController: CharactersListViewInput {
    func update(with characters: [Character]) {
        self.characters = characters
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.tableView.reloadData()
        }
    }
    
    func showUpdateFailure() {
        activityIndicator.stopAnimating()
        router.showUpdateFailureError()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CharactersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router.showDetails(for: characters[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharactersListCell", for: indexPath) as? CharactersListCell else {
            return UITableViewCell()
        }
        let character = characters[indexPath.row]
        cell.configure(with: character.imageUrl, name: character.name)
        cell.selectionStyle = .none
        return cell
    }
}

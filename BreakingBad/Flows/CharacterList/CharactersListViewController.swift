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
        
        title = "Characters"
        
        configureTableView()
        configureSubvies()
        
        activityIndicator.startAnimating()
        interactor.viewLoaded()
    }
    
    private func configureSubvies() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            view.topAnchor.constraint(equalTo: tableView.topAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            view.centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: activityIndicator.centerYAnchor)
        ])
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 84
        let nib = UINib(nibName: "CharactersListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CharactersListCell")
    }
}

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

// MARK: UITableViewDelegate, UITableViewDataSource

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

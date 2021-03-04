//
//  UserListViewController.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 3.03.21.
//

import UIKit

protocol UserListViewInput: class {
    func update(with profiles: [Profile])
}

class UserListViewController: UIViewController {
    var interactor: UserListInteractorInput
    var router: UserListRouterInput
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private var profiles: [Profile] = []
    
    init(interactor: UserListInteractorInput,
         router: UserListRouterInput) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureLayout()
        
        interactor.fetchData()
        
        
        
        
        // TEMP:
        let setupBlock: ((Profile) -> Void) = { profile in
            profile.name = "Svetoslav"
            profile.imageUrl = "someURL"
            profile.nickname = "Svetlio"
            profile.occupation = "Software engineer"
            profile.seasonAppearance = "Some appearance"
            profile.status = "engaged"
        }
        (UIApplication.shared.delegate as? AppDelegate)?.coreDataManager.insert(setupBlock: setupBlock)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "UserListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UserListCell")
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            view.topAnchor.constraint(equalTo: tableView.topAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
        ])
    }
}

extension UserListViewController: UserListViewInput {
    func update(with profiles: [Profile]) {
        self.profiles = profiles
        tableView.reloadData()
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as? UserListCell else {
            return UITableViewCell()
        }
        let profile = profiles[indexPath.row]
        cell.configure(with: profile.imageUrl, name: profile.name)
        return cell
    }
}

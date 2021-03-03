//
//  UserListViewController.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 3.03.21.
//

import UIKit

protocol UserListViewInput: class {
    
}

class UserListViewController: UIViewController, UserListViewInput {
    var interactor: UserListInteractorInput
    var router: UserListRouterInput
    
    private let tableView = UITableView()
    
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
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
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

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        return UITableViewCell()
    }
}

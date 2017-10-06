//
//  InterestsListViewController.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/6/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import UIKit

class InterestsListViewController: UITableViewController {
    
    var interests: [String] = []
    var selectedCellIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseDatabaseManager.shared.getInterestsList { result in
            switch result {
            case .failure(with: let error):
                print(error.localizedDescription)
            case .success(user: let value):
                print(type(of: value))
                if let valueDict = value as? NSDictionary {
                    for (key, _) in valueDict {
                        self.interests.append(key as! String)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "interestsCell")!
        cell.textLabel?.text = interests[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Interests"
    }
    

}

//
//  InterestsListViewController.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/6/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import UIKit

class InterestsListViewController: UITableViewController {
    
    let interestsRef = FirebaseDatabaseManager.shared.interestsReference
    var interests: [String] = []
    var selectedInterests: Set<String>!

    override func viewDidLoad() {
        super.viewDidLoad()
        interestsRef
            .queryOrdered(byChild: "name")
            .observe(.value, with:
                { snapshot in
                    var interests: [String] = []
                    guard let values = snapshot.value as? Dictionary<String, Any> else {
                        return
                    }
                    for (key, _) in values {
                        interests.append(key)
                    }
                    self.interests = interests
                    self.tableView.reloadData()
            })
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "interestsCell")!
        cell.textLabel?.text = interests[indexPath.row]
        cell.accessoryType = selectedInterests.contains(cell.textLabel!.text!) ?
                            .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
            selectedInterests.insert(cell.textLabel!.text!)
        } else {
            cell.accessoryType = .none
            selectedInterests.remove(cell.textLabel!.text!)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Interests"
    }
    
    
}

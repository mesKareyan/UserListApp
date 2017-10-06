//
//  UserListViewController.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/5/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leftViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftView: UIView!
    
    let usersListRef = FirebaseDatabaseManager.shared.usersReference
    var users: [UserData] = []
    
    struct Constants {
        static let cellID = "userCell"
        struct SegueID {
            static let leftView = "leftView"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        congigureUI()
        usersListRef.observe(.value, with: { snapshot in
            var usersList: [UserData] = []
            for item in snapshot.children {
                let groceryItem = UserData(snapshot: item as! DataSnapshot)
                usersList.append(groceryItem)
            }
            self.users = usersList
            self.tableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let segueIdentifier = segue.identifier else {
            return
        }
        switch segueIdentifier {
        case Constants.SegueID.leftView:
            (segue.destination as! LeftViewController).leftViewDelegate = self
        default:
            break
        }
    }
    
    func congigureUI() {
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        leftViewLeftConstraint.constant = -leftView.bounds.width
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleLeftViewSwipe(recognizer:)))
        leftView.addGestureRecognizer(pan)
    }
    
    //MARK: - Actions
    @IBAction func menuButtonTapped(_ sender: UIBarButtonItem) {
        if leftViewLeftConstraint.constant == 0 {
            leftViewLeftConstraint.constant = -leftView.bounds.width
        } else {
            leftViewLeftConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleLeftViewSwipe(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: leftView)
        var xConstant = translation.x
        var animationDuration = 0.1
        if xConstant > 0 {
            xConstant = 0
        }
        switch recognizer.state {
        case .cancelled, .failed, .ended:
            //hide left view if needed
            if xConstant < -50 {
                xConstant =  -leftView.bounds.width
                animationDuration = 0.3
            } else {
                 xConstant = 0
                animationDuration = 0.2
            }
        default:
            break
        }
        leftViewLeftConstraint.constant = xConstant
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

//MARK - Table view
extension UserListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID) as! UserTableViewCell
        cell.userData = users[indexPath.row]
        return cell
    }
    
}

extension UserListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: ", indexPath)
    }
}

extension UserListViewController: LeftViewDelegate {
    
    func profileRowTapped() {
        
    }
    
    func feedbackRowTapped() {
        
    }
    
    func infoRowTapped() {
        
    }
    
    func signOutRowTapped() {
        
        let alert = UIAlertController(title: "Sign out ?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
       
    }
    
    
}

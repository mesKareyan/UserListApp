//
//  UserListViewController.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/5/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leftViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftView: UIView!
    
    struct Constants {
        static let cellID = "userCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        congigureUI()
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID) as! UserTableViewCell
        cell.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        return cell
    }
    
}

extension UserListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: ", indexPath)
    }
    
}

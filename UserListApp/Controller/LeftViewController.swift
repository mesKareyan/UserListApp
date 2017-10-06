//
//  LeftViewController.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/5/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import UIKit
import SDWebImage

class LeftViewController: UITableViewController {

    private var leftborderAdded = false
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        counfigureUI()
    }
    
    func counfigureUI(){
        guard !leftborderAdded else {
            return
        }
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.borderWidth = 3.0
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.masksToBounds = true
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.appBlue.cgColor
        border.frame = CGRect(x: tableView.frame.width - width,
                              y: 0,
                              width: width,
                              height: tableView.frame.height)
        border.borderWidth = width
        tableView.layer.addSublayer(border)
        tableView.layer.masksToBounds = true
        leftborderAdded = true
        //User ui
        let currentUser = UserManager.currentUserData
        if let avatarURL = currentUser?.avatarURL {
            profileImageView.sd_setImage(
                with: URL(string: avatarURL),
                placeholderImage: #imageLiteral(resourceName: "User")
            )
        }
        profileNameLabel.text = currentUser?.name

    }

}

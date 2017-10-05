//
//  ProfileEditingViewController.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/5/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import UIKit

class ProfileEditingViewController: UITableViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    
    var navBarImage: UIImage!
    var navBarShadowImge: UIImage!
    var navBarIsTranslucent: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent != nil {
            navBarImage = navigationController?.navigationBar.backgroundImage(for: .default)
            navBarShadowImge = navigationController?.navigationBar.shadowImage
            navBarIsTranslucent = navigationController?.navigationBar.isTranslucent
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
        } else {
            navigationController?.navigationBar.setBackgroundImage(navBarImage, for: .default)
            navigationController?.navigationBar.shadowImage = navBarShadowImge
            navigationController?.navigationBar.isTranslucent = navBarIsTranslucent
        }
    }
    
    func configureUI(){
        navigationController?.navigationBar.tintColor = UIColor.white
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2.0
        userNameTextField.layer.cornerRadius = userNameTextField.bounds.height / 2.0
        userNameTextField.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    }

}

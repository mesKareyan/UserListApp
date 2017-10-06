//
//  ProfileEditingViewController.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/5/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: UITableViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var interestsTextView: UITextView!
    @IBOutlet weak var interestChangeButton: UIButton!
    
    var isEditable = true
    var user: UserData!
    
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
        [nameTextField, emailTextField, ageTextField].forEach {
            $0?.isEnabled = self.isEditable
        }
        interestsTextView.isEditable = self.isEditable
        interestChangeButton.isHidden = !self.isEditable
        //configure user data
        if let avatarURL = user.avatarURL {
            userImageView.sd_setImage(
                with: URL(string: avatarURL),
                placeholderImage: #imageLiteral(resourceName: "User")
            )
        }
        nameTextField.text = user.name
        userNameTextField.text = user.name
        emailTextField.text = user.email
        if let userAge = user.age {
            ageTextField.text =  String(userAge)
        }
        let interestsString = user.interests.reduce("") { (result, next) -> String in
            return result  + " ," + next
        }
        interestsTextView.text = interestsString
    }
    
    //MARK: Actions

    @IBAction func interestChengeButtonTapped(_ sender: UIButton) {
    }
    
}

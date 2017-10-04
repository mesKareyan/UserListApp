//
//  ViewController.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/4/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    enum ControllerType {
        case signin
        case signup
        static prefix func !(type: ControllerType) -> ControllerType {
            switch type {
            case .signin:
                return signup
            case .signup:
                return signin
            }
        }
    }
    var controllerType: ControllerType = .signin{
        didSet {
            self.loginLabel.alpha = 0.0
            UIView.animate(withDuration: 0.4, animations: {
                self.loginStackView.alpha = 0.0
                self.loginStackView.transform =
                    CGAffineTransform(scaleX: 1.0, y: 0.1)
                        .concatenating(
                            CGAffineTransform(translationX: 0.0, y: self.loginStackView.bounds.height))
            }) { fin  in
                UIView.animate(withDuration: 0.4, animations: {
                    self.loginStackView.alpha = 1.0
                    self.loginStackView.transform = .identity
                    self.loginLabel.alpha = 1.0
                }, completion: nil)
            }
            switch controllerType {
            case .signin:
                loginButton.setTitle("Sign in", for: .normal)
                loginLabel.text = "Sign in"
            case .signup:
                loginButton.setTitle("Sign up", for: .normal)
                loginLabel.text = "Sign up"
            }
        }
    }
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginStackView: UIStackView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLoginButtonContriner: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var fbLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: Initialization
    func configureUI() {
        //facebook login button
        let container = facebookLoginButtonContriner!
        fbLoginButton = FBSDKLoginButton(frame: .zero)
        container.addSubview(fbLoginButton)
        fbLoginButton.translatesAutoresizingMaskIntoConstraints = false
        fbLoginButton.leftAnchor.constraint(equalTo:
            container.leftAnchor).isActive = true
        fbLoginButton.rightAnchor.constraint(equalTo:
            container.rightAnchor).isActive = true
        fbLoginButton.topAnchor.constraint(equalTo:
            container.topAnchor).isActive = true
        fbLoginButton.bottomAnchor.constraint(equalTo:
            container.bottomAnchor).isActive = true
        //counfigure Views
        [loginButton,
         facebookLoginButtonContriner,
         fbLoginButton,
         usernameTextField,
         passwordTextField]
            .forEach { view in
                guard let view = view else { return }
                view.clipsToBounds = true
                view.layer.cornerRadius = view.bounds.height / 2.0
        }
        func configureFiled(_ textFiled: UITextField) {
            let image: UIImage
            if textFiled == usernameTextField {
                image = #imageLiteral(resourceName: "User")
            } else {
                image = #imageLiteral(resourceName: "Unlock")
            }
            let leftImageView = UIImageView(image: image)
            leftImageView.tintColor =  UIColor.groupTableViewBackground
            if let size = leftImageView.image?.size {
                leftImageView.frame = CGRect(x: 0.0,
                                             y: 0.0,
                                             width: size.width + 30,
                                             height: size.height)
            }
            leftImageView.contentMode = .center
            textFiled.leftView = leftImageView
            textFiled.leftViewMode = .always
            textFiled.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            
        }
        configureFiled(usernameTextField)
        configureFiled(passwordTextField)
    }
    //MARK: - Actions
    @IBAction func newUserButtonTapped(_ sender: UIButton) {
        controllerType = !controllerType
    }
    
}


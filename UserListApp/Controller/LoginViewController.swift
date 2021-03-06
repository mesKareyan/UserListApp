//
//  ViewController.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/4/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import APESuperHUD
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textFieldsBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginStackView: UIStackView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLoginButtonContriner: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextFiled: UITextField!
    
    var fbLoginButton: FBSDKLoginButton!
    @IBOutlet weak var loginModeSwitcherButton: UIButton!
    
    struct Constants {
        private init(){}
        struct SegueID {
            static let userListSegueID = "showUserList"
            static let showVerifySegueID = "showVerify"
        }
    }
    
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
                self.loginStackView.transform = CGAffineTransform(scaleX: 1.0,y: 0.1)
                    .concatenating(CGAffineTransform(translationX: 0.0,
                                                     y: self.loginStackView.bounds.height))
            }) { fin  in
                UIView.animate(withDuration: 0.4, animations: {
                    self.loginStackView.alpha = 1.0
                    self.loginStackView.transform = .identity
                    self.loginLabel.alpha = 1.0
                    self.passwordConfirmTextFiled.isHidden =
                        (self.controllerType == .signin)
                }, completion: nil)
            }
            switch controllerType {
            case .signin:
                loginButton.setTitle("Sign in", for: .normal)
                loginLabel.text = "Sign in"
                loginModeSwitcherButton.setTitle("Create new user", for: .normal)
            case .signup:
                loginButton.setTitle("Sign up", for: .normal)
                loginLabel.text = "Sign up"
                loginModeSwitcherButton.setTitle("Go to sigin", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addActions()
        if let user = Auth.auth().currentUser {
            APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
            UserManager.fetch(user: user) {
                DispatchQueue.main.async {
                    APESuperHUD.removeHUD(animated: true, presentingView: self.view)
                    if UserManager.currentUserData.isFacebookUser || user.isEmailVerified {
                        self.performSegue(withIdentifier: Constants.SegueID.userListSegueID, sender: nil)
                    }
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textFieldsBottomConstraint.constant = 8
        FBSDKLoginManager().logOut()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let identifer = segue.identifier else {
            return
        }
        if identifer == Constants.SegueID.showVerifySegueID {
            let verifyController = segue.destination as! EmailVerifyViewController
            verifyController.verifyComletion = {
                self.controllerType = .signin
            }
        }
    }
    
    //MARK: - Initialization
    func configureUI() {
        loginButton.isEnabled = false
        //facebook login button
        let container = facebookLoginButtonContriner!
        fbLoginButton = FBSDKLoginButton(frame: .zero)
        fbLoginButton.readPermissions = ["public_profile", "email"]
        fbLoginButton.delegate = self
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
        passwordConfirmTextFiled.isHidden = true
        [loginButton,
         facebookLoginButtonContriner,
         fbLoginButton,
         usernameTextField,
         passwordTextField,
         passwordConfirmTextFiled]
            .forEach {  view in
                guard let view = view else { return }
                view.clipsToBounds = true
                view.layer.cornerRadius = view.bounds.height / 2.0
                if let textFiled = view as? UITextField {
                    configureFiled(textFiled)
                }
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
        //Configure HUD
        APESuperHUD.appearance.backgroundBlurEffect = .light
        APESuperHUD.appearance.defaultDurationTime = 2.0
        APESuperHUD.appearance.hudSquareSize = 250
        APESuperHUD.appearance.animateInTime = 0.4
        APESuperHUD.appearance.animateOutTime = 1.0
    }
    
    func addActions() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: .UIKeyboardWillHide, object: nil)
        [usernameTextField,
         passwordConfirmTextFiled,
         passwordTextField].forEach { textField in
            textField?.addTarget(self,
                                 action: #selector(textFieldDidChange(textField:)),
                                 for: .editingChanged)
            textField?.delegate = self
        }
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }
    
    @objc func endEditing(){
        self.view.endEditing(true)
    }
    
    //MARK: - Actions
    @IBAction func newUserButtonTapped(_ sender: UIButton) {
        controllerType = !controllerType
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard,
                                    message: "Signin in ..",
                                    presentingView: view)
        switch controllerType {
        case .signin:
            signin { result in
                self.signInComplited(with: result)
            }
        case .signup:
            signup { result in
                self.signUpComplited(with: result)
            }
        }
    }
    
    func signInComplited(with result: LoginResult) {
        self.view.isUserInteractionEnabled = true
        switch result {
        case .failure(with: let error):
            showError(error)
        case .success(user: let user):
            APESuperHUD.removeHUD(animated: true, presentingView: self.view)
            userDidSignedIn(user: user, isFacebookUser: false)
        }
    }
    
    func signUpComplited(with result: LoginResult) {
        self.view.isUserInteractionEnabled = true
        switch result {
        case .failure(with: let error):
            showError(error)
        case .success(user: let user):
            APESuperHUD.removeHUD(animated: true, presentingView: self.view)
            userDidSignedUp(user: user, isFacebookUser: false)
        }
    }
    
    
    func showError(_ error: Error) {
        APESuperHUD.showOrUpdateHUD(icon: .sadFace,
                                    message: "Can't login \n" + error.localizedDescription,
                                    presentingView: self.view)
    }
    
}

//MARK: - Text Fields
extension LoginViewController: UITextFieldDelegate {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            textFieldsBottomConstraint.constant = 110
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            textFieldsBottomConstraint.constant = 8
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        loginButton.isEnabled = checkTextFields()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            passwordConfirmTextFiled.text = ""
        }
        return true
    }
    
    func checkTextFields() -> Bool {
        guard let nameText = usernameTextField.text,
            let passwordText = passwordTextField.text
            else {
                return false
        }
        if self.controllerType == .signup {
            guard let passwordConfirmText = passwordConfirmTextFiled.text else {
                return false
            }
            if  passwordConfirmText != passwordText {
                return false
            }
        }
        if passwordText.count < 6 || !nameText.isValidEmail() {
            return false
        }
        return true
    }
    
}

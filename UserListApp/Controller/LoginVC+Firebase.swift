//
//  LoginVC+Firebase.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/5/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import APESuperHUD

enum LoginResult {
    case success(user: User)
    case failure(with: Error)
}

enum FirbaseLoginError : Error {
    case emailLoginError
    case facebookLoginError
}

typealias LoginCompletion = (LoginResult) -> ()

//MARK: Firebase login
extension LoginViewController {
    
    func userDidSignedIn(user: User) {
        performSegue(withIdentifier: Constants.userListSegueID, sender: nil)
    }
    
    //signup with email
    func signup(completion: @escaping LoginCompletion) {
        guard  let email = usernameTextField.text,
            let password = passwordTextField.text else {
                return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                completion(.failure(with: error!))
                return
            }
            guard let _ = user else {
                completion(.failure(with: FirbaseLoginError.emailLoginError))
                return
            }
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, erroor) in
                guard error == nil else {
                    completion(.failure(with: error!))
                    return
                }
                guard let user = user else {
                    completion(.failure(with: FirbaseLoginError.emailLoginError))
                    return
                }
                UserManager.createNew(user: user)
                completion(.success(user: user))
            })
        }
    }
    
    //signin with email
    func signin(completion: @escaping LoginCompletion) {
        guard  let email = usernameTextField.text,
            let password = passwordTextField.text else {
                return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                completion(.failure(with: error!))
                return
            }
            guard let user = user else {
                completion(.failure(with: FirbaseLoginError.emailLoginError))
                return
            }
            completion(.success(user: user))
        }
    }
}

//MARK: Facebook login
extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!,
                     didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        guard error == nil else {
            self.showError(error!)
            return
        }
        guard !result.isCancelled else {
            return
        }
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard,
                                    funnyMessagesLanguage: .english,
                                    presentingView: view)
    
        getFacebookData { result in
            
            switch result {
            case .failure(with: let error):
                self.showError(error)
            case .success(user: let data):
                
                let userDataDict = data as! Dictionary<String, String>
                
                let credential = FacebookAuthProvider.credential(withAccessToken:
                    FBSDKAccessToken.current().tokenString)
                Auth.auth().signIn(with: credential) { (user, error) in
                    APESuperHUD.removeHUD(animated: true, presentingView: self.view)
                    guard error == nil else {
                        self.showError(error!)
                        return
                    }
                    guard let user = user else {
                        self.showError(FirbaseLoginError.facebookLoginError)
                        return
                    }
                    //signed in
                    UserManager.createNew(user: user)
                    self.userDidSignedIn(user: user)
                }
            }
        }
        
    }
    
    private func getFacebookData(comletion: @escaping RequestCompletion) {
        
        let parameters = ["fields": "email,name,picture.type(large)"]
        let graphRequest = FBSDKGraphRequest(graphPath: "me",
                                             parameters: parameters)!
        graphRequest.start(completionHandler: { (connection, result, error) in
            if let error = error  {
                self.showError(error)
                comletion(.failure(with: error))
            } else {
                guard let resultDict = result as? Dictionary<String, Any>  else {
                    comletion(.failure(with: RequestError.facebookError))
                    return
                }
                var dataDict: Dictionary<String, String> = [:]
                if let name = resultDict["name"] as? String {
                    dataDict["name"] = name
                }
                if let email = resultDict["email"] as? String {
                    dataDict["email"] = email
                }
                if let pictureURL = (resultDict["picture"]
                    as? Dictionary<String, Dictionary<String,Any>>)?["data"]?["url"] as? String {
                    dataDict["avatar"] = pictureURL
                }
                comletion(.success(user: dataDict))
            }
        })
    }
    
}


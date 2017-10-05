//
//  LoginVC+Firebase.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/5/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import UIKit
import FirebaseAuth

enum LoginResult {
    case success(user: User)
    case failure(with: Error)
}

enum FirbaseLoginError : Error {
    case userLoginError
}

typealias LoginCompletion = (LoginResult) -> ()

//MARK: Firebase login
extension LoginViewController {
        
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
            guard let user = user else {
                completion(.failure(with: FirbaseLoginError.userLoginError))
                return
            }
            completion(.success(user: user))
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
                completion(.failure(with: FirbaseLoginError.userLoginError))
                return
            }
            completion(.success(user: user))
        }
    }
    
}


//
//  UserManager.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/6/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import Foundation
import Firebase

class UserManager {
    
    private init(){}
    static private(set) var currentUserData: UserData!
    
    static func create(user firebaseUser: Firebase.User, new: Bool) {
        currentUserData = UserData(fireBaseUser: firebaseUser)
        //currentUserData.getInterests()
        if new {
            FirebaseDatabaseManager.shared.usersListAdd(user: currentUserData)
        }
    }
    
    static func updateUser(name: String) {
        let changeRequest = currentUserData.fireBaseUser.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges { (error) in
            guard error == nil else {
                return
            }
            currentUserData.name = name
            currentUserData.databaseUserRef.updateChildValues([
                "name": name
                ])
        }
    }
    
    static func updateUser(age: Int) {
        currentUserData.age = age
        currentUserData.databaseUserRef.updateChildValues([
            "age": age
            ])
    }
    
    static func updateUser(interests: [String]) {
        currentUserData.interests = interests
        currentUserData.databaseUserRef.updateChildValues([
            DatabaseReferencePath.interests: interests
            ])
    }
    
    static func updateUser(image: UIImage, completion: @escaping () -> ()) {
        guard let data = UIImagePNGRepresentation(image) else {
            return
        }
        FirebaseStorageManager
            .uploadImage(withData: data,
                         name: currentUserData.id)
            { result in
                switch result {
                case .failure(with: let error):
                    print(error.localizedDescription)
                case .success(URL: let imageURL):
                    updateUser(imageURL: imageURL)
                }
                completion()
        }
    }
    
    private static func updateUser(imageURL: URL) {
        let changeRequest = currentUserData.fireBaseUser.createProfileChangeRequest()
        changeRequest.photoURL = imageURL
        changeRequest.commitChanges { (error) in
            guard error == nil else {
                return
            }
            currentUserData.avatarURL = imageURL.absoluteString
            currentUserData.databaseUserRef.updateChildValues([
                "avatar": imageURL.absoluteString
                ])
            NotificationCenter.default.post(name: .ulapp_userImageChanged, object: nil)
        }
    }
    
    static func updateUser(signatureImage: UIImage, completion: @escaping () -> ()) {
        guard let data = UIImagePNGRepresentation(signatureImage) else {
            return
        }
        FirebaseStorageManager
            .uploadImage(withData: data,
                         name: currentUserData.id + "+signature")
            { result in
                switch result {
                case .failure(with: let error):
                    print(error.localizedDescription)
                case .success(URL: let imageURL):
                    updateUser(signatureURL: imageURL)
                }
                completion()
        }
    }
    
    private static func updateUser(signatureURL: URL) {
            currentUserData.signatureURL = signatureURL.absoluteString
            currentUserData.databaseUserRef.updateChildValues([
                "signature": signatureURL.absoluteString
                ])
    }
    
}

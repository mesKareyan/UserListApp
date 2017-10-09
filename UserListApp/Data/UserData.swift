//
//  UserData.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/6/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class UserData {
    
    let id:           String
    let email:        String?
    var name:         String?
    var age:          Int?
    var avatarURL:    String?
    var signatureURL: String?
    var interests:    [String]!
    
    var provider:     String?
    var isFacebookUser: Bool {
        return provider == "facebook"
    }
    
    var databaseUserRef: DatabaseReference!
    var fireBaseUser: User!
    
    init(fireBaseUser: Firebase.User) {
        //get data from firebase Auth
        self.email     = fireBaseUser.email
        self.name      = fireBaseUser.displayName
        self.avatarURL = fireBaseUser.photoURL?.absoluteString
        self.id        = fireBaseUser.uid
        self.fireBaseUser   = fireBaseUser
        self.databaseUserRef = FirebaseDatabaseManager.shared
            .usersReference.child(fireBaseUser.uid)
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! NSDictionary
        self.id = "unknown"
        self.provider = "unknown"
        if let provider = snapshotValue["provider"] as? String {
            self.provider = provider 
        }
        if let age = snapshotValue["age"] as? Int {
            self.age = age
        }
        if let avatarURL = snapshotValue["avatar"] as? String {
            self.avatarURL = avatarURL
        }
        if let signatureURL = snapshotValue["signature"] as? String {
            self.signatureURL = signatureURL
        }
        if let email = snapshotValue["email"] as? String {
            self.email = email
        } else {
            self.email = "unknown"
        }
        if let name = snapshotValue["name"] as? String {
            self.name = name
        }
        if snapshot.hasChild(DatabaseReferencePath.interests) {
            if  let interestsSnapValue = snapshot.childSnapshot(
                forPath: DatabaseReferencePath.interests).value as? NSArray {
                let interests = interestsSnapValue as! [String]
                self.interests = interests
            }
        }
        self.databaseUserRef = snapshot.ref
    }
    
    //MARK: Utils
    func getProvider(comletion: @escaping () -> ()) {
        self.databaseUserRef.child(DatabaseReferencePath.provider)
            .observeSingleEvent(of: .value, with: { snapshot in
                if let provider = snapshot.value as? String {
                    self.provider  = provider
                }
                comletion()
            })
    }
    
    func getInterests() {
        self.databaseUserRef.child(DatabaseReferencePath.interests)
            .observeSingleEvent(of: .value, with: { snapshot in
                if let values = snapshot.value as? [String] {
                    self.interests  = values
                }
            })
    }
    
    func getSignatureURL() {
        self.databaseUserRef.child("signature")
            .observe(.value) { snapshot in
                if let urlString = snapshot.value as? String {
                    self.signatureURL = urlString
                }
        }
    }
    
    var dictRepresentation: Dictionary<String, Any> {
        var dict = [String: Any]()
        if let email = email {
            dict["email"] = email
        }
        if let name = name {
            dict["name"] = name
        }
        if let age = age {
            dict["age"] = String(age)
        }
        if let avatar = avatarURL {
            dict["avatar"] = avatar
        }
        if let provider = provider {
            dict["provider"] = provider
        }
        dict["intersts"] = self.interests
        return dict
    }
    
}

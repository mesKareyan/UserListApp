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
    
    let id:     String
    let email:  String?
    var name:   String?
    var age:    Int?
    var avatarURL: String?
    var interests: [String] = []

    var databaseUserRef: DatabaseReference!
    var fireBaseUser: User!
    
    init(fireBaseUser: Firebase.User) {
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
        if let age = snapshotValue["age"] as? Int {
            self.age = age
        }
        if let avatar = snapshotValue["avatar"] as? String {
            self.avatarURL = avatar
        }
        if let email = snapshotValue["email"] as? String {
            self.email = email
        } else {
            self.email = "unknown"
        }
        if let name = snapshotValue["name"] as? String {
            self.name = name
        }
        if snapshot.hasChild("interests") {
            if  let interestsSnapValue = snapshot.childSnapshot(
                forPath: "interests").value as? NSDictionary {
                let interests = interestsSnapValue.allKeys as! [String]
                self.interests = interests
            }
        }
        self.databaseUserRef = snapshot.ref
    }
    
    var dictRepresentation: Dictionary<String, String> {
        var dict = [String: String]()
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
        return dict
    }
    
}

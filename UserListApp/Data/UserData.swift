//
//  UserData.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/6/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct UserData {
    
    let email:  String
    let id:     String
    var name:   String?
    var age:    Int?
    var avatarURL: String?
    
    init(id: String, email: String) {
        self.email = email
        self.id = id
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
    }
    
    var dictRepresentation: Dictionary<String, String> {
        var dict = [
            "email" : email,
            ]
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

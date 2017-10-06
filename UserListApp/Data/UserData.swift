//
//  UserData.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/6/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import Foundation

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

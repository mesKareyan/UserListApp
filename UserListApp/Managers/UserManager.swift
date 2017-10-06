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
    //static let shared = UserManager()
    static var currentUserData: UserData!
    
    static func createNew(user: Firebase.User) {
        currentUserData = UserData(id: user.uid, email: user.email!)
        FirebaseDatabaseManager.shared.usersListAdd(user: currentUserData)
    }
    
    static func updateUser(with userData: UserData) {
        currentUserData = userData
        FirebaseDatabaseManager.shared.usersListAdd(user: currentUserData)
    }
    
}

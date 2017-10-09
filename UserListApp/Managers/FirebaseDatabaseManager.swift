//
//  FirebaseManager.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/5/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

enum RequestResult {
    case success(user: Any)
    case failure(with: Error)
}

typealias RequestCompletion = (RequestResult) -> ()

enum RequestError: Error {
    case unknown
    case facebookError
}

struct DatabaseReferencePath {
    private init(){}
    static let interests = "interests"
    static let users = "users"
    static let provider = "provider"
}

class FirebaseDatabaseManager {
    
    private init() {
        dbReference = Database.database().reference()
        interestsReference = Database.database()
            .reference(withPath:DatabaseReferencePath.interests)
        usersReference = Database.database()
            .reference(withPath: DatabaseReferencePath.users)
    }
    static let shared = FirebaseDatabaseManager()
    
    //refs
    let dbReference: DatabaseReference
    let interestsReference: DatabaseReference
    let usersReference: DatabaseReference
    
    func usersListAdd(user: UserData) {
        let usersRef = dbReference.child(DatabaseReferencePath.users)
        let userRef = usersRef.child(user.id)
        userRef.observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() {
                //set new user data in firebase uid
                usersRef.child(user.id).setValue(user.dictRepresentation)
            }
        }
    }
    
    func user(withID userUID: String, result: @escaping ((DatabaseReference?) ->())) {
        usersReference.observe(.value) { snap in
            if snap.hasChild(userUID) {
                let ref = self.usersReference.child(userUID)
                result(ref)
            }
            else {
                result(nil)
            }
        }
    }
        
}

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
                usersRef.child(user.id).setValue(user.dictRepresentation)
            }
        }
    }
    
    func getInterestsList(completion: @escaping RequestCompletion) {
        dbReference
            .child(DatabaseReferencePath.interests)
            .observeSingleEvent(of: .value, with: { snapshot in
                if let value = snapshot.value {
                        completion(.success(user: value))
                } else {
                        completion(.failure(with: RequestError.unknown))
                }
                    
            })
            { error in
                completion(.failure(with: error))
        }
    }
    
    
}

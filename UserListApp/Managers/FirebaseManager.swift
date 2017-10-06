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

class FirebaseDatabaseManager {
    
    private init() { dbReference = Database.database().reference() }
    static let shared = FirebaseDatabaseManager()
    var dbReference: DatabaseReference!
    
    private struct DatabaseStructure {
        private init(){}
        static let interests = "interests"
        static let users = "users"
    }
    
    func usersListAdd(user: UserData) {
        let usersRef = dbReference.child(DatabaseStructure.users)
        usersRef.child(user.id).setValue(user.dictRepresentation)
    }
    
    func getInterestsList(completion: @escaping RequestCompletion) {
        dbReference
            .child(DatabaseStructure.interests)
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

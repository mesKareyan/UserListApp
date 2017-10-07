//
//  FirebaseStorageManager.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/6/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import Foundation
import FirebaseStorage

enum UploadResult {
    case success(URL: URL)
    case failure(with: Error)
}

enum UploadError : Error {
    case unknown
}

typealias UploadCompletion = (UploadResult) -> ()

class FirebaseStorageManager {
    
    private init(){}
    
    static let storage = Storage.storage()
    static var storageRef: StorageReference {
        return storage.reference()
    }
    static var imagesRef: StorageReference {
        return storageRef.child("images")
    }
    
    static func uploadImage(withData imageData: Data,
                     name: String,
                     comletion: @escaping UploadCompletion) {
        // Data in memory
        // Create a reference to the file you want to upload
        let imageRef = storageRef.child("images/\(name).jpg")
        // Upload the file to the path "images/\(name).jpg"
        let uploadTask = imageRef
            .putData(imageData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    comletion(.failure(with: UploadError.unknown))
                    return
                }
                guard let url = metadata.downloadURL() else {
                    comletion(.failure(with: UploadError.unknown))
                    return
                }
                comletion(.success(URL: url))
        }
        uploadTask.resume()
    }
    
}

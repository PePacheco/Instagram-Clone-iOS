//
//  StorageManager.swift
//  Instagram-Clone
//
//  Created by Pedro Gomes Rubbo Pacheco on 27/03/21.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    public func downloadURL(for post: Post, completion: @escaping (URL?) -> Void) {
        guard let ref = post.storageReference else {
            completion(nil)
            return
        }
        storage.child(ref).downloadURL { url, _ in
            completion(url)
        }
    }
    
    public func downloadProfileURL(for username: String, completion: @escaping (URL?) -> Void) {
        storage.child("\(username)/profile_picture.png").downloadURL { url, _ in
            completion(url)
        }
    }
    
    public func uploadPost(
        data: Data?,
        id: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let username = UserDefaults.standard.string(forKey: "username"),
              let data = data else {
            return
        }
        storage.child("\(username)/posts/\(id).png").putData(data, metadata: nil) { _, error in
            completion(error == nil)
        }
    }
    
    public func uploadProfilePicture(
        username: String,
        data: Data?,
        completion: @escaping (Bool) -> Void
    ) {
        guard let data = data else {
            return
        }
        storage.child("\(username)/profile_picture.png").putData(data, metadata: nil) { _, error in
            completion(error == nil)
        }
    }
}

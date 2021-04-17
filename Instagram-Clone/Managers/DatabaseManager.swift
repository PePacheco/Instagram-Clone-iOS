//
//  DatabaseManager.swift
//  Instagram-Clone
//
//  Created by Pedro Gomes Rubbo Pacheco on 27/03/21.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private init() {}
    
    let databaase = Firestore.firestore()
    
    public func findUser(with email: String, completion: @escaping (User?) -> Void) {
        let ref = databaase.collection("users")
        ref.getDocuments { snapshot, error in
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data()) }), error == nil else {
                completion(nil)
                return
            }
            let user = users.first(where: { $0.email == email })
            completion(user)
        }
    }
    
    public func createUser(newUser: User, completion: @escaping (Bool) -> Void) {
        let reference = databaase.document("users/\(newUser.username)")
        guard let dataUser = newUser.asDictionary() else {
            completion(false)
            return
        }
        reference.setData(dataUser) { error in
            completion(error == nil)
        }
    }
}

//
//  AuthManager.swift
//  Instagram-Clone
//
//  Created by Pedro Gomes Rubbo Pacheco on 27/03/21.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    
    enum AuthError: Error {
        case newUserCreation
    }
    
    static let shared = AuthManager()
    
    let auth = Auth.auth()
    
    private init() {}
    
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    public func signIn(email: String,
                       password: String,
                       completion: @escaping (Result<User, Error>) -> Void
    ) {}
    
    public func signUp(email: String,
                       username: String,
                       password: String,
                       profilePicture: Data?,
                       completion: @escaping (Result<User, Error>) -> Void
    ) {
        let newUser = User(username: username, email: email)
        // Create account
        auth.createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(.failure(AuthError.newUserCreation))
                return
            }
            
            DatabaseManager.shared.createUser(newUser: newUser) { success in
                if success {
                    StorageManager.shared.uploadProfilePicture(
                        username: username,
                        data: profilePicture
                    ) { uploadSuccess in
                        if uploadSuccess {
                            completion(.success(newUser))
                        } else {
                            completion(.failure(AuthError.newUserCreation))
                        }
                    }
                } else {
                    completion(.failure(AuthError.newUserCreation))
                }
            }
        }
    }
    
    public func signOut(completion: @escaping (Bool) -> Void ) {
        do {
            try auth.signOut()
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }
}

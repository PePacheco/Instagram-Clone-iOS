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
}

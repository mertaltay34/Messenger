//
//  Database.swift
//  Messenger
//
//  Created by Mert Altay on 17.08.2023.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
}
    //MARK: - Account Management
extension DatabaseManager{
    public func userExists(with email: String, completion: @escaping(Bool) -> Void){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-") // db ye gönderirken @ ve . kullanımına izin verilmiyor. bu yüzden değişiklik yapıldı.
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? [String: Any] != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    /// Inserts new user  to database
    public func insertUser(with user: ChatAppUser){
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }
}
struct ChatAppUser{
    let firstName: String
    let lastName: String
    let emailAddress: String
//   let profilePictrueUrl: String
    var  safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

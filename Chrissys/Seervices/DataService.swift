//
//  DataService.swift
//  Chrissys
//
//  Copyright © 2019 Chrissys. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase
let DB_BASE = Database.database().reference()

class DataService {
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }

    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_USERFIRSTNAME = DB_BASE.child("users").child("firstname")
    private var _REF_USERLASTNAME = DB_BASE.child("users").child("lastname")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    
    }
    
    
}

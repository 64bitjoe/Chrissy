//
//  AuthService.swift
//  Chrissys
//
//  Copyright © 2019 Chrissys. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase



typealias Completion = (_ errMsg: String? , _ data:  AnyObject?) -> Void
class AuthService  {
    private static let  _instance = AuthService()
    static var instance: AuthService {
        return _instance
    }

    
    func login(email: String, password: String, onComplete: Completion?) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
if error != nil {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    if errorCode == .userNotFound {
                        // dispaly error message
                    } else {
                    Auth.auth().signIn(withEmail: email, password: password, completion:
                        { (user, error) in
                            if error != nil {
                                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                            } else {
                                //successfuly logged in

                                //Download profile photo with kingfisher
                                onComplete?(nil, user)

                            }
                    })
                }
                } else {
                    self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
    }
    
    
} else {
        onComplete?(nil, user)
            }
            
        }
    }
//    func register(withEmail email: String, andPassword password: String, userCreationComplete: @escaping(_ status: Bool, _ error: Error?) -> ()) {
//        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
//            guard let authDataResult = authDataResult else {
//                userCreationComplete(false, error)
//                return
//            }
//
//            let userData = ["provider": authDataResult.user.providerID, "email" : authDataResult.user.email]
//            DataService.instance.createDBUser(uid: authDataResult.user.uid, userData: userData)
//            userCreationComplete(true, nil)
//        }
//    }

    func register(withEmail email: String, andPassword password: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
            guard let authData = authData?.user else {
                userCreationComplete(false, error)
                
                
                return
            }
            
            let userData = ["provider": authData.providerID, "email": authData.email, "firstname":authData.displayName]
            DataService.instance.createDBUser(uid: authData.uid, userData: userData as Dictionary<String, Any>)
            userCreationComplete(true, nil)
        }
    }
    
    
    
    func logout(){
        do {
            try Auth.auth().signOut()
            
        }
        catch {
            print(error)
        }
        
    }
    func handleFirebaseError(error : NSError, onComplete: Completion?) {
        print(error.debugDescription)
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch (errorCode) {
            case .invalidEmail:
                onComplete?("Invalid email adress", nil)
                break
            case .wrongPassword :
                onComplete?("Invalid password", nil)
                break
            case .emailAlreadyInUse :
                onComplete?("Could not create account email already in use.", nil)
             break
            case .accountExistsWithDifferentCredential :
                onComplete?("Could not create account email already in use.", nil)
                break
            case .weakPassword :
                onComplete?("Password is too week!", nil)
                break
            default :
                onComplete?("There was a problem with the authorization of this sesson. Try again.", nil)
                
                //
            }
        }
    }
}

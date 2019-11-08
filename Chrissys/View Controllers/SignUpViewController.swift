//
//  SignUpViewController.swift
//  Chrissys
//
//  Copyright © 2019 Chrissys. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Photos

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var tcLabel: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
    
    lazy var storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tcLabel.text = TC_LBL
        signUpLabel.text = SU_LBL
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard  let email = emailField.text,
            let password = passwordField.text,
            let firstName = firstName.text,
            let lastName = lastName.text else {return}
            let username = firstName + " " + lastName
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .long
            let timeStamp =  formatter.string(from: currentDateTime)
        
        
        if (email.count > 0 && password.count > 0 ) {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    let alert = UIAlertController(title: ERR_AUTH_SU , message: error.localizedDescription , preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    debugPrint("Error creating user: \(error.localizedDescription)")
                }
                let changeReuest = user?.user.createProfileChangeRequest()
                changeReuest?.displayName = firstName + " " + lastName
                changeReuest?.commitChanges(completion: { (error) in
                    if let error = error {
                        debugPrint(error.localizedDescription)
                    }
                })
                guard let userId = user?.user.uid else {return}
                Firestore.firestore().collection("users").document(userId).setData([
                    USERNAME : username,
                    DATE_CREATED : timeStamp
                    ], completion: { (error ) in
                        if let error = error {
                            debugPrint(error.localizedDescription)
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                })
            }
            
       }
        else {
            let alert = UIAlertController(title: ERR_AUTH_INVALID_FEILD, message: ERR_AUTH_INVALID_FEILD_REG_DETAIL, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
    }
    




}

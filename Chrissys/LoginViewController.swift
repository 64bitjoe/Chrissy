 
 //
//  LoginViewController.swift
//  
//
//

import UIKit
import Firebase
import FirebaseAuth
import Kingfisher
import CodableFirebase
import FirebaseFirestore
class LoginViewController: UIViewController , UITextFieldDelegate {

    //Outlets
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    //Var
        let cache = ImageCache.default
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordField.delegate = self
        emailField.delegate = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginButton(sender: AnyObject) {

        if let email = emailField.text, let pass = passwordField.text, (email.count > 0 && pass.count > 0) {
            
            AuthService.instance.login(email: email, password: pass) { (errMsg, data) in
                guard errMsg == nil else {
                    let alert = UIAlertController(title: ERR_AUTH , message: errMsg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print(ERR_AUTH_DETAIL)
                    
                    return
                }

                Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).getDocument { document, error in
                    if let document = document {
                        let model = try! FirestoreDecoder().decode(Model.self, from: document.data()!)
                        print("Model: \(model.IMGURL)")
                        let imgURL = URL(string: model.IMGURL)
                        KingfisherManager.shared.retrieveImage(with: imgURL!) { result in
                            self.profileImageView.kf.setImage(with: imgURL)
                            self.cache.store(self.profileImageView.image!, forKey: "profileImage")
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
                self.dismiss(animated: true, completion: nil)
            }
            
        } else {
            let alert = UIAlertController(title: ERR_AUTH_INVALID_FEILD, message: ERR_AUTH_INVALID_FEILD_DETAIL, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }

    }
    @IBAction func signupButton(sender: AnyObject) {
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    @IBAction func dissmissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
 }



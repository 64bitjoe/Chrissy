//
//  UserPageViewController.swift
//  Chrissys
//
//  Copyright © 2019 Chrissys. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Photos
import FirebaseStorage
import CodableFirebase
import Kingfisher

class UserPageViewController: UIViewController {
    
    @IBOutlet weak var taptToChangeProfileButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userSince: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var imagePicker:UIImagePickerController!
    lazy var storage = Storage.storage()
    let cache = ImageCache.default
    private var imageKey: String?
    lazy var userCollection = Firestore.firestore().collection("users")
        var userDataFromServer = [Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = "@" +  (Auth.auth().currentUser?.displayName ?? "Name")
        logoutButton.layer.cornerRadius = 7
        logoutButton.clipsToBounds = true
        closeButton.layer.cornerRadius = 15
        logoutButton.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
        tap.numberOfTapsRequired = 1
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tap)

        profileLogic()

    }
    override func viewDidAppear(_ animated: Bool) {
        guard Auth.auth().currentUser != nil else {
            performSegue(withIdentifier: "loginPush", sender: nil)
            return
            
        }
        profileLogic()
    }
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = self.randomImage()
        userNameLabel.text = "@" +  (Auth.auth().currentUser?.displayName ?? "Name")
        profileLogic()
    }
    let ImageArray = [
        "userBG.jpeg",
        "userBG-1.jpeg",
        "userBG-2.jpeg",
    ]


    /*
    // MARK: - Navigation
    */
    @IBAction func testButton(_ sender: Any) {
//        readUserdata()
    }
    
    @IBAction func exitButton(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    @IBAction func logoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.cache.clearDiskCache()
            self.profileImageView.image = UIImage(named: "profile")
            self.dismiss(animated: true, completion: nil)
        } catch let err {
            print(err.localizedDescription)
        }

        // MARK: - Background Image Randomizer
    }
    func randomImage() -> UIImage {
        let unsignedArrayCount = UInt32(ImageArray.count)
        let unsignedRandomNumber = arc4random_uniform(unsignedArrayCount)
        let randomNumber = Int(unsignedRandomNumber)
        return UIImage(named: ImageArray[randomNumber])!
    }
    
    // MARK: - Image Upload
    

    func uploadDocument(){
        let image = profileImageView.image
        guard let imageData = image?.jpegData(compressionQuality: 0.2 ) else  { return }
        
        let imageRef = Storage.storage().reference().child("/users/\(Auth.auth().currentUser!.uid).jpg")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    return
                }
                guard let url = url else { return }
                
                let userID = Auth.auth().currentUser?.uid
                print(userID!)
                Firestore.firestore().collection("users").document(userID!).setData([
                    "IMGURL" : url.absoluteString
                ],merge: true,  completion: { (error ) in
                        if let error = error {
                            debugPrint(error.localizedDescription)
                        } else {
                           
                        }
                })
                self.cache.clearMemoryCache()
                self.cache.clearDiskCache { print("Done") }
                self.cache.diskStorage.config.expiration = .never
                self.profileImageView.kf.setImage(with: url)

                self.cache.store(image!, forKey: "profileImage")
            })
        }
    }


    @objc func imgTapped(_ tap: UITapGestureRecognizer) {
        launchImgPicker()
    }


    func profileLogic() {
        if Auth.auth().currentUser == nil {
            print("Nobody Home")
            DispatchQueue.main.async { [weak self] in
                let img = UIImage(named: "profile")
                self!.profileImageView.image = img
            }
            
        } else {
            cache.retrieveImage(forKey: "profileImage") { result in
                switch result {
                case .success(let value):
                    print(value.cacheType)
                    
                    // If the `cacheType is `.none`, `image` will be `nil`.
                    DispatchQueue.main.async { [weak self] in
                        let img =  value.image
                self!.profileImageView.image = img
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async { [weak self] in
                        print("not saved in key")
                        print(error.localizedDescription)
                        let img = UIImage(named: "profile")
                self!.profileImageView.image = img
                    }
                    
                }
                
            }
        }
        
    }

    
}

extension UserPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func  launchImgPicker()  {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.image = image
        self.dismiss(animated: true, completion: nil)
        uploadDocument()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
    
}

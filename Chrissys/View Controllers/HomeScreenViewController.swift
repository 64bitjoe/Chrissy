//
//  ViewController.swift
//  Chrissys
//
//  Copyright © 2019 Chrissys. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseAuth

class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Outlets
    @IBOutlet weak var timeOfDayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userButton: UIButton!
    //Variables
    var greeting = ""
    var cellAction = [UIImage]()
    var cellActionLabel = [String]()
     let cache = ImageCache.default

    
    override func viewDidLoad() {
        super.viewDidLoad()
        greetingLogic()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.bounces = false
        cellAction =  [#imageLiteral(resourceName: "mealPrepButton"), #imageLiteral(resourceName: "cateringButton"), #imageLiteral(resourceName: "privateChefButton") , #imageLiteral(resourceName: "cateringButton") ]
        cellActionLabel = [HOME_MAIN_LBL_0, HOME_MAIN_LBL_1, HOME_MAIN_LBL_2, HOME_MAIN_LBL_3]
        profileLogic()

        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.profileLogic()
        

        self.userButton.layer.cornerRadius = 37
        self.userButton.layer.shadowColor = UIColor.gray.cgColor
        self.userButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.userButton.layer.borderColor = UIColor.lightGray.cgColor
        self.userButton.layer.borderWidth = 2
        self.userButton.layer.shadowOpacity = 1
        self.userButton.layer.shadowRadius = 2.0
        self.userButton.clipsToBounds = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 4
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeScreenTableViewCell
        
    let row = indexPath.row
    //        cell.cellDelegate = self
    cell.cellActionImage.image = cellAction[row]
    cell.cellActionItem.text = cellActionLabel[row]
    cell.cellActionImage.layer.shadowColor = UIColor.gray.cgColor
    cell.cellActionImage.layer.shadowOffset = CGSize(width: 0, height: 1)
    cell.cellActionImage.layer.shadowOpacity = 1
   cell.cellActionImage.layer.shadowRadius = 1.0
    cell.cellActionImage.clipsToBounds = false
    cell.indexPath = indexPath
    return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let controller = storyboard?.instantiateViewController(withIdentifier: "mealPrep")
            self.navigationController!.pushViewController(controller!, animated: true)
            
        }  else if indexPath.row == 1 {
            
    
        } else if indexPath.row == 2 {
            
        }
        else if indexPath.row == 3 {

        } else if indexPath.row == 4 {

        }
        
    }


    @IBAction func meetTheFounderBtn(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: HOME_BASE_LBL_0)
        self.navigationController!.pushViewController(controller!, animated: true)
    }
    
    @IBAction func ourTeam(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: HOME_BASE_LBL_1)
        self.navigationController!.pushViewController(controller!, animated: true)
    }
    
    @IBAction func ourVison(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: HOME_BASE_LBL_2)
        self.navigationController!.pushViewController(controller!, animated: true)
    }
    
    func greetingLogic() {
        let date = NSDate()
        let calendar = NSCalendar.current
        let currentHour = calendar.component(.hour, from: date as Date)
        let hourInt = Int(currentHour.description)!
        
        if hourInt >= 12 && hourInt <= 16 {
            greeting = HOME_GREET_0
        }
        else if hourInt >= 7 && hourInt <= 12 {
            greeting = HOME_GREET_1
        }
        else if hourInt >= 16 && hourInt <= 20 {
            greeting = HOME_GREET_2
        }
        else if hourInt >= 20 && hourInt <= 24 {
            greeting = HOME_GREET_3
        }
        else if hourInt >= 0 && hourInt <= 7 {
            greeting = HOME_GREET_4
        }
        
        timeOfDayLabel.text = greeting
    }

    func profileLogic() {
        if Auth.auth().currentUser == nil {
//            print("Nobody Home")
            DispatchQueue.main.async { [weak self] in
                let img = UIImage(named: "profile")
                self!.userButton.setImage(img, for: .normal)
            }
            
        } else {
            cache.retrieveImage(forKey: "profileImage") { result in
                switch result {
                case .success(let value):
                    print(value.cacheType)
                    
                    // If the `cacheType is `.none`, `image` will be `nil`.
                    DispatchQueue.main.async { [weak self] in
                        let img =  value.image
                        self?.userButton.setImage(img, for: .normal)
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async { [weak self] in
                        print("not saved in key")
                        print(error.localizedDescription)
                        let img = UIImage(named: "profile")
                        self?.userButton.setImage(img, for: .normal)
                    }
                    
                }

            }
        }
        
    }
    
    
    
    
    
    
    
}


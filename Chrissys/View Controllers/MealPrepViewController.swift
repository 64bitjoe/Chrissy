//
//  MealPrepViewController.swift
//  Chrissys
//
//  Copyright © 2019 Chrissys. All rights reserved.
//

import UIKit

class MealPrepViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let launchedBefore = UserDefaults.standard.bool(forKey: "launchednever")
        if launchedBefore {
            print("Not First Launch")
        } else {
             performSegue(withIdentifier: "mealSplash", sender: nil)
             UserDefaults.standard.set(true, forKey: "launchednever")
        }
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
 
    @IBAction func DONTKEEPBUTTON(_ sender: Any) {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
        
    }
    
}

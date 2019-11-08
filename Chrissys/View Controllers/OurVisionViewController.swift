//
//  OurMissionViewController.swift
//  Chrissys
//
//  Copyright © 2019 Chrissys. All rights reserved.
//

import UIKit

class OurVisionViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.cornerRadius = 15
        backgroundView.clipsToBounds = true
        navigationController?.navigationBar.prefersLargeTitles = true
        

    }


}

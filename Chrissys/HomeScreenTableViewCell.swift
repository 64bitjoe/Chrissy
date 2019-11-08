//
//  HomeScreenTableViewCell.swift
//  Chrissys
//

//  Copyright © 2019 Chrissys. All rights reserved.
//

import UIKit

class HomeScreenTableViewCell: UITableViewCell {
        var indexPath:IndexPath!
    @IBOutlet weak var cellActionImage: UIImageView!
    
    @IBOutlet weak var cellActionItem: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

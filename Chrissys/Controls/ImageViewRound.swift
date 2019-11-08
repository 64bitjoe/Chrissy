//
//  ImageViewRound.swift
//  Chrissys
//
//  Copyright © 2019 Chrissys. All rights reserved.
//

import Foundation
import UIKit

class roundImageView: UIImageView {
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        // 2. call super.init(frame:)
        super.init(frame: frame)
        // 3. Setup view from .xib file
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        // 3. Setup view from .xib file
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = self.frame.size.width/2
                self.layer.masksToBounds = true
    }
}

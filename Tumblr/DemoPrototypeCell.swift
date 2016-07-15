//
//  DemoPrototypeCell.swift
//  Tumblr
//
//  Created by Rajiv Deshmukh on 7/14/16.
//  Copyright © 2016 Rajiv Deshmukh. All rights reserved.
//

import UIKit

class DemoPrototypeCell: UITableViewCell {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

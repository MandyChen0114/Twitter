//
//  MenuCell.swift
//  Twitter
//
//  Created by Mandy Chen on 10/7/17.
//  Copyright © 2017 Mandy Chen. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var menuLabel: UILabel!
    
    var menuItem:String!{
        didSet {
            menuLabel.text = menuItem
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

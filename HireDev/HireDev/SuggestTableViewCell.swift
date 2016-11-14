//
//  SuggestTableViewCell.swift
//  Hippo
//
//  Created by Jeff Eom on 2016-11-14.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit

class SuggestTableViewCell: UITableViewCell {
   
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

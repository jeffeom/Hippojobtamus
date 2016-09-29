//
//  JobTableViewCell.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-29.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit

class JobTableViewCell: UITableViewCell {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    //MARK: UITableViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

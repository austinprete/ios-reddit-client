//
//  PostCell.swift
//  reddit-client
//
//  Created by Austin Prete on 7/14/15.
//  Copyright (c) 2015 Austin Prete. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postKarmaLabel: UILabel!
    @IBOutlet weak var postAuthorLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

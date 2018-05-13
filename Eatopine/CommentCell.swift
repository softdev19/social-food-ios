//
//  CommentCell.swift
//  Eatopine
//
//  Created by Eden on 9/18/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbComment: UILabel!
    @IBOutlet weak var lbCommentTime: UILabel!    
}

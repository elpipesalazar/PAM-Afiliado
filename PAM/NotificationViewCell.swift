//
//  NotificationViewCell.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 16-10-16.
//  Copyright © 2016 Wingzoft. All rights reserved.
//

import UIKit

class NotificationViewCell: MGSwipeTableCell {
    @IBOutlet weak var notificationText: UILabel!
    @IBOutlet weak var icoNotification: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

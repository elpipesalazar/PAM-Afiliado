//
//  TrackingViewCell.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 17-12-15.
//  Copyright © 2015 Wingzoft. All rights reserved.
//

import UIKit

class TrackingViewCell: MGSwipeTableCell {
    @IBOutlet weak var service: UILabel!
    @IBOutlet weak var dateRequest: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

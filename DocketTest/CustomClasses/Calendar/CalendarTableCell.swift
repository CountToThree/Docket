//
//  CalendarTableCell.swift
//  DocketTest
//
//  Created by Max on 19.01.19.
//  Copyright © 2019 1409revest. All rights reserved.
//

import UIKit

class CalendarTableCell: UITableViewCell {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        colorView.layer.cornerRadius = colorView.frame.height / 2
        
    }
}

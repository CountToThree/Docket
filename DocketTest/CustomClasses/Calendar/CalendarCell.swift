//
//  CalendarCell.swift
//  DocketTest
//
//  Created by Max on 17.01.19.
//  Copyright © 2019 1409revest. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var leftColorView: UIView!
    @IBOutlet weak var midColorView: UIView!
    @IBOutlet weak var rightColorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftColorView.layer.cornerRadius = leftColorView.frame.width / 2
        midColorView.layer.cornerRadius = midColorView.frame.width / 2
        rightColorView.layer.cornerRadius = rightColorView.frame.width / 2

        midColorView.backgroundColor = .black
    }
}

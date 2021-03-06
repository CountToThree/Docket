//
//  TaskCell.swift
//  DocketTest
//
//  Created by Max on 29.11.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskInfoLabel: UILabel!
    @IBOutlet weak var checkBox: CheckBox!
    @IBOutlet weak var checkBoxImage: CustomCheckBox!
    
    func setupCheckBox() {
        checkBox.setup()
        checkBoxImage.setup()
    }
}

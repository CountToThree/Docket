//
//  CheckBox.swift
//  DocketTest
//
//  Created by Max on 14.12.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit

class CheckBox: UIView {
    
    func setup() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGreen.cgColor
    }
}

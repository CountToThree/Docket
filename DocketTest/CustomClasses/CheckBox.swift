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
        self.layer.borderColor = UIColor(red: 165/255, green: 209/255, blue: 176/255, alpha: 1.0).cgColor
    }
}

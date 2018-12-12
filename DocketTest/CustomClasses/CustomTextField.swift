//
//  CustomTextField.swift
//  DocketTest
//
//  Created by Max on 29.11.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    var myBorderColor = UIColor(red: 165/255, green: 209/255, blue: 176/255, alpha: 1.0)
    
    func setup() {
        self.layer.borderWidth = 1
        self.layer.borderColor = myBorderColor.cgColor
        self.layer.cornerRadius = 1
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        self.leftViewMode = .always
    }
}

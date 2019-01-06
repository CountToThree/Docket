//
//  CSTextField.swift
//  DocketTest
//
//  Created by Max on 26.12.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit

class CSTextField: CustomTextField {
    
    func setup() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        self.textColor = .white
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        self.leftViewMode = .always
        self.font = UIFont.systemFont(ofSize: 12)
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)])
        self.addDoneButtonOnKeyboard()
    }
}

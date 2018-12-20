//
//  SortingButtons.swift
//  DocketTest
//
//  Created by Max on 15.12.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit

class SortingButton: UIButton {
    
    var active = false
    
    func setup() {
        self.layer.borderWidth = 1
        self.layer.borderColor = lightGreen.cgColor
        self.layer.cornerRadius = 3
        self.tintColor = lightGreen
    }
    
    func didSelect() {
        UIView.animate(withDuration: 0.4) {
            self.alpha = 1.0
        }
        active = true
    }
    
    func didUnselect() {
        UIView.animate(withDuration: 0.4) {
            self.alpha = 0.3
        }
        active = false
    }
    
}

//
//  CustomCheckBox.swift
//  DocketTest
//
//  Created by Max on 13.12.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit

class CustomCheckBox: UIImageView {
    
    func setup() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGreen.cgColor
        self.layer.masksToBounds = true
        self.image = UIImage(named: "checkMark")
    }
    
    func taskComplete() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
            self.tapAnimation()
        }
    }
    
    func taskNotComplete() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0.0
            self.tapAnimation()
        }
    }
    
    private func tapAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (true) in
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
    }
    
}

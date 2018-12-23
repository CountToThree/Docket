//
//  ContainerViewController.swift
//  DocketTest
//
//  Created by Max on 22.12.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuView: UIView!
    
    var isMenuVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(triggerSideMenu), name: .toggleSideMenu, object: nil)
    }
    
    @objc func triggerSideMenu() {
        if isMenuVisible {
            sideMenuConstraint.constant = -240
            isMenuVisible = false
        } else {
            sideMenuConstraint.constant = 0
            isMenuVisible = true
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}

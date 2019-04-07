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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showSideMenu), name: .showSideMenu, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideSideMenu), name: .hideSideMenu, object: nil)
    }
    
    @objc func showSideMenu() {
        sideMenuConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func hideSideMenu() {
        sideMenuConstraint.constant = -240
    
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

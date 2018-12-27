//
//  FirstViewController.swift
//  DocketTest
//
//  Created by Max on 24.12.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var LogInBtn: CSButton!
    @IBOutlet weak var SignUpBtn: CSButton!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var greenBGView: UIView!
    @IBOutlet weak var iconCenterYConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogInBtn.setup()
        SignUpBtn.setup()
        greenBGView.bounds.size.width = self.view.bounds.width
        print(greenBGView.bounds.width," " , self.view.bounds.width, " FIRST")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateView()

    }
    
    func animateView() {
        viewBottomConstraint.constant = -145
        print("ASDF")
        //iconCenterYConstraint.constant = -50 //(greenBGView.bounds.height / 2)
        print(greenBGView.bounds.height / 2)
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
        print(greenBGView.bounds.width, " SECOND")
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
}

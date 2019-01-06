//
//  FirstViewController.swift
//  DocketTest
//
//  Created by Max on 24.12.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit
import Firebase

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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            print("user already logged in")
            performSegue(withIdentifier: "main", sender: self)
        } else {
            print("You have to log in")
            animateView()
        }

    }
    
    func animateView() {
        viewBottomConstraint.constant = -145
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
}

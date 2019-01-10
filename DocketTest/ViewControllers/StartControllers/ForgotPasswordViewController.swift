//
//  ForgotPasswordViewController.swift
//  DocketTest
//
//  Created by Max on 10.01.19.
//  Copyright © 2019 1409revest. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTF: CSTextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.setup()
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        if emailTF.text != "" {
            SVProgressHUD.show()
        
            Auth.auth().sendPasswordReset(withEmail: emailTF.text!) { (error) in
                if error != nil {
                    self.errorLabel.textColor = lightRed
                    self.errorLabel.text = error?.localizedDescription
                    SVProgressHUD.dismiss()
                } else {
                    self.errorLabel.textColor = .white
                    self.errorLabel.text = "Email was sent successfully."
                    SVProgressHUD.dismiss()
                }
            }
        } else {
            errorLabel.text = "Please enter a email address."
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

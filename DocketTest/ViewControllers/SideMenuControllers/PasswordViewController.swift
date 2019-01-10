//
//  PasswordViewController.swift
//  DocketTest
//
//  Created by Max on 10.01.19.
//  Copyright © 2019 1409revest. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PasswordViewController: UIViewController {
    
    @IBOutlet weak var oldPwTF: CustomTextField!
    @IBOutlet weak var newPwTF: CustomTextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldPwTF.setup()
        newPwTF.setup()
        
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        SVProgressHUD.show()
        
        let email = Auth.auth().currentUser?.email
        Auth.auth().signIn(withEmail: email!, password: oldPwTF.text!) { (result, error) in
            if error != nil {
                print(error ?? "")
                self.errorLabel.textColor = lightRed
                self.errorLabel.text = error?.localizedDescription
                SVProgressHUD.dismiss()
            } else {
                self.setNewPassword()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func setNewPassword() {
        errorLabel.textColor = lightRed
        guard let _ = newPwTF.text else {
            errorLabel.text = "You have to enter a new password."
            return
        }
        Auth.auth().currentUser?.updatePassword(to: newPwTF.text!, completion: { (error) in
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
            } else {
                self.errorLabel.textColor = lightGreen
                self.errorLabel.text = "Password updated successfully."
            }
        })
    }
    
}

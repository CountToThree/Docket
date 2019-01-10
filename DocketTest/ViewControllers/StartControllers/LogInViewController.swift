//
//  LogInViewController.swift
//  DocketTest
//
//  Created by Max on 26.12.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {
    
    @IBOutlet weak var EmailLogInTF: CSTextField!
    @IBOutlet weak var PasswordLogInTF: CSTextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EmailLogInTF.setup()
        PasswordLogInTF.setup()
    }
    
    @IBAction func passwordEditingBegin(_ sender: Any) {
        PasswordLogInTF.moveSuperViewUp()
    }
    
    @IBAction func passwordEditingEnd(_ sender: Any) {
        PasswordLogInTF.moveSuperViewDown()
    }
    
    @IBAction func LogInPressed(_ sender: Any) {
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: EmailLogInTF.text!, password: PasswordLogInTF.text!) { (result, error) in
            if error != nil {
                print(error ?? "")
                self.errorLabel.text = error?.localizedDescription
                SVProgressHUD.dismiss()
            } else {
                self.performSegue(withIdentifier: "toHomeVC", sender: self)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    @IBAction func resetPassowrdPressed(_ sender: Any) {
        performSegue(withIdentifier: "showForgotPassword", sender: self)
    }
    
    @IBAction func BackBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

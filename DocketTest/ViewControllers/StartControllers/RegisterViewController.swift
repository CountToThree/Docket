//
//  RegisterViewController.swift
//  DocketTest
//
//  Created by Max on 26.12.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var FirstNameTF: CSTextField!
    @IBOutlet weak var EmailTF: CSTextField!
    @IBOutlet weak var PasswordTF: CSTextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirstNameTF.setup()
        EmailTF.setup()
        PasswordTF.setup()
    }
    
    @IBAction func emailEditingBegin(_ sender: Any) {
        EmailTF.moveSuperViewUp()
    }
    
    @IBAction func emailEditingEnd(_ sender: Any) {
        EmailTF.moveSuperViewDown()
    }
    
    @IBAction func passwordEditingBegin(_ sender: Any) {
        PasswordTF.moveSuperViewUp()
    }
    
    @IBAction func passwordEditingEnd(_ sender: Any) {
        PasswordTF.moveSuperViewDown()
    }
    
    @IBAction func SignUpPressed(_ sender: Any) {        
        //Create new Firebase account
        if FirstNameTF.text != "" {
            SVProgressHUD.show()
            Auth.auth().createUser(withEmail: EmailTF.text!, password: PasswordTF.text!) { (result, error) in
                if error != nil {
                    print(error ?? "")
                    self.errorLabel.text = error?.localizedDescription
                    SVProgressHUD.dismiss()
                } else {
                    print("Registration successful")
                    SVProgressHUD.dismiss()
                    let nameRef = Database.database().reference().child("users/\(Auth.auth().currentUser?.uid ?? "")/name")
                    nameRef.setValue(["firstName": self.FirstNameTF.text])
                    self.performSegue(withIdentifier: "toHomeVC", sender: self)
                }
            }
        } else {
            errorLabel.text = "Please enter your first name."
            SVProgressHUD.dismiss()
        }
        
        
    }
    @IBAction func BackBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

//
//  RegisterViewController.swift
//  DocketTest
//
//  Created by Max on 26.12.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var FirstNameTF: CSTextField!
    @IBOutlet weak var EmailTF: CSTextField!
    @IBOutlet weak var PasswordTF: CSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirstNameTF.setup()
        EmailTF.setup()
        PasswordTF.setup()
    }
    
    @IBAction func SignUpPressed(_ sender: Any) {
        //Create new Firebase account
        Auth.auth().createUser(withEmail: EmailTF.text!, password: PasswordTF.text!) { (result, error) in
            if error != nil {
                print(error ?? "")
            } else {
                print("Registration successful")
                let nameRef = Database.database().reference().child("users/\(Auth.auth().currentUser?.uid ?? "")/name")
                nameRef.setValue(["firstName": self.FirstNameTF.text])
                self.performSegue(withIdentifier: "toHomeVC", sender: self)
            }
        }
        
        
    }
    @IBAction func BackBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
}

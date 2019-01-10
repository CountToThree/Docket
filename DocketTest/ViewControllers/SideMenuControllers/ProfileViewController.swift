//
//  ProfileViewController.swift
//  DocketTest
//
//  Created by Max on 23.12.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ProfileViewController: UIViewController {
    @IBOutlet weak var editNameTF: CustomTextField!
    @IBOutlet weak var editEmailTF: CustomTextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    let ref = Database.database().reference()
    var name = ""
    
    //MARK: - Project Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        editNameTF.setup()
        editEmailTF.setup()
        setTFdata()
    }
    
    func setTFdata() {
        let nameRef = ref.child("users/\(Auth.auth().currentUser?.uid ?? "")/name")
        nameRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            self.name = (snapshotValue?["firstName"] as? String)!
            self.editNameTF.text = self.name
        }) { (error) in
            self.errorLabel.textColor = lightRed
            self.errorLabel.text = error.localizedDescription
        }
        
        editEmailTF.text = Auth.auth().currentUser?.email
    }
    
    
    //MARK: - Button Setups
    @IBAction func saveBtnPressed(_ sender: Any) {
        SVProgressHUD.show()
        if editEmailTF.text != Auth.auth().currentUser?.email && editEmailTF.text != "" {
            Auth.auth().currentUser?.updateEmail(to: editEmailTF.text!, completion: { (error) in
                if error != nil {
                    self.errorLabel.textColor = lightRed
                    self.errorLabel.text = error?.localizedDescription
                } else {
                    self.errorLabel.textColor = lightGreen
                    self.errorLabel.text = "Saved successfully."
                }
            })
        }
        if editNameTF.text != name && editNameTF.text != "" {
            let nameRef = ref.child("users/\(Auth.auth().currentUser?.uid ?? "")/name/firstName")
            nameRef.setValue(editNameTF.text)
            errorLabel.textColor = lightGreen
            errorLabel.text = "Saved successfully"
            NotificationCenter.default.post(name: .updateFirstName, object: nil)
        }
        SVProgressHUD.dismiss()
    }
    @IBAction func editPwPressed(_ sender: Any) {
        performSegue(withIdentifier: "showEditPassword", sender: self)
    }
    
}

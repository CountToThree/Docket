//
//  NewListPopUp.swift
//  DocketTest
//
//  Created by Max on 28.11.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit
import Firebase

class NewListPopUp: UIViewController {
    
    @IBOutlet weak var nameTextField: CustomTextField!
    
    let userRef = Database.database().reference().child("users")

    override func viewDidLoad() {
        nameTextField.setup()
    }
    
    @IBAction func nameEditingBegin(_ sender: Any) {
        nameTextField.moveSuperViewUp()
    }
    
    @IBAction func nameEditingEnd(_ sender: Any) {
        nameTextField.moveSuperViewDown()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddButtonPressed(_ sender: UIButton) {
        //NotificationCenter.default.post(name: .saveNewListName, object: self)
        let newItem = ListItem(name: nameTextField.text!, listID: UUID().uuidString)
        let listDB = userRef.child((Auth.auth().currentUser?.uid)!).child(newItem.listID)
        listDB.setValue(newItem.toAnyObject()) {
            (error, ref) in
            if error != nil {
                print(error ?? "")
            } else {
                print("Message saved successfully")
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
}

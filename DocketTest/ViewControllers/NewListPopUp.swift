//
//  NewListPopUp.swift
//  DocketTest
//
//  Created by Max on 28.11.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit

class NewListPopUp: UIViewController {
    
    
    @IBOutlet weak var nameTextField: CustomTextField!
    
    override func viewDidLoad() {
        nameTextField.setup()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddButtonPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: .saveNewListName, object: self)
        
        dismiss(animated: true, completion: nil)
    }
    
}

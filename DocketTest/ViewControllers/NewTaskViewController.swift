//
//  NewTaskViewController.swift
//  DocketTest
//
//  Created by Max on 29.11.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit

class NewTaskViewController: UIViewController {
    
    @IBOutlet weak var taskNameTF: CustomTextField!
    @IBOutlet weak var taskInfoTF: CustomTextField!
    @IBOutlet weak var prioritySlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskNameTF.setup()
        taskInfoTF.setup()
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: .saveNewTaskItems, object: self)
        navigationController?.popViewController(animated: true)
    }
}

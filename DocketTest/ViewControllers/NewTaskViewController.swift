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
    @IBOutlet weak var PrioritySButton: SortingButton!
    @IBOutlet weak var CreationSButton: SortingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskNameTF.setup()
        taskInfoTF.setup()
        PrioritySButton.setup()
        CreationSButton.setup()
        CreationSButton.didSelect()
        PrioritySButton.didUnselect()
    }
    @IBAction func PriorityBtnPressed(_ sender: Any) {
        PrioritySButton.didSelect()
        CreationSButton.didUnselect()
    }
    
    @IBAction func CreationBtnPressed(_ sender: Any) {
        PrioritySButton.didUnselect()
        CreationSButton.didSelect()
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: .saveNewTaskItems, object: self)
        navigationController?.popViewController(animated: true)
    }
}

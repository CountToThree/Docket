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
    @IBOutlet weak var colorTextField: CustomTextField!
    @IBOutlet weak var colorView: UIView!
    
    var pickerView = UIPickerView()
    var pickerData = ["None", "Blue", "Red", "Yellow", "Green", "Black"]
    let userRef = Database.database().reference().child("users")
    var selectedColor = ""
    
    override func viewDidLoad() {
        nameTextField.setup()
        colorTextField.setup()
        pickerViewSetup()
    }
    
    func pickerViewSetup() {
        colorView.layer.cornerRadius = colorView.bounds.width / 2
        colorView.backgroundColor = lightGreen
        
        pickerView.delegate = self
        colorTextField.inputView = pickerView
    }
    
    //MARK: - Textfield Editings
    @IBAction func nameEditingBegin(_ sender: Any) {
        nameTextField.moveSuperViewUp()
    }
    
    @IBAction func nameEditingEnd(_ sender: Any) {
        nameTextField.moveSuperViewDown()
    }
    
    @IBAction func colorEditingBegin(_ sender: Any) {
        colorTextField.moveSuperViewUp()
    }
    
    @IBAction func colorEditingEnd(_ sender: Any) {
        colorTextField.moveSuperViewDown()
    }
    
    //MARK: - Button Setup
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddButtonPressed(_ sender: UIButton) {
        //NotificationCenter.default.post(name: .saveNewListName, object: self)
        let newItem = ListItem(name: nameTextField.text!, color: selectedColor, listID: UUID().uuidString)
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

extension NewListPopUp: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        colorTextField.text = pickerData[row]
        selectedColor = pickerData[row]
        colorView.backgroundColor = UIColor.setColor(at: pickerData[row])
    }
}

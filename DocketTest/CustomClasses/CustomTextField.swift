//
//  CustomTextField.swift
//  DocketTest
//
//  Created by Max on 29.11.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    var datePicker = UIDatePicker()
    var isDatePicker = false
    
    func setup(datePicker: Bool? = nil) {
        self.layer.borderWidth = 1
        self.layer.borderColor = lightGreen.cgColor
        self.layer.cornerRadius = 1
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        self.leftViewMode = .always
        if let usesDatePicker = datePicker {
            isDatePicker = usesDatePicker
        }
        self.addDoneButtonOnKeyboard()
    }
    
    //MARK: - On Textfield touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Textfield touched")
        if !self.isEditing {
            if self.center.y > (superview?.bounds.height)! / 2 {
                print("Textfield below Keyboard")
//                UIView.animate(withDuration: 0.4) {
//                    self.superview!.frame.origin.y -= self.center.y - (self.superview?.bounds.height)! / 2 + self.bounds.height
//                }
                UIView.animate(withDuration: 0.4, delay: 0.3, options: .curveEaseInOut, animations: {
                    self.superview!.frame.origin.y = self.superview!.frame.origin.y - (self.center.y - (self.superview?.bounds.height)! / 2 + self.bounds.height)
                }, completion: nil)
            }
        }
    }

    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancelAction))
        if isDatePicker {
            done.action = #selector(self.datePickerDoneAction)
            setDatePicker()
        }
        done.tintColor = lightGreen
        cancel.tintColor = lightGreen
        let items = [cancel, flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
        moveSuperView()
    }
    
    @objc func cancelAction() {
        self.resignFirstResponder()
        self.text = ""
        self.moveSuperView()
    }
    
    //MARK: - Date Picker Setup
    @objc func datePickerDoneAction() {
        print("date picker done action")
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm a"
        self.text = formatter.string(from: datePicker.date)
        self.resignFirstResponder()
        moveSuperView()
    }
    
    func setDatePicker() {
        datePicker.datePickerMode = .dateAndTime
        self.inputView = datePicker
    }
    
    func moveSuperView() {
        if superview!.frame.origin.y != 0 {
            //superview!.frame.origin.y = 0
            UIView.animate(withDuration: 0.2) {
                self.superview!.frame.origin.y = 0
            }
        }
    }
}

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
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        if isDatePicker {
            done.action = #selector(self.datePickerDoneAction)
            setDatePicker()
        }
        done.tintColor = lightGreen
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
    //MARK: Date Picker Setup
    @objc func datePickerDoneAction() {
        print("date picker done action")
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm a"
        self.text = formatter.string(from: datePicker.date)
        self.resignFirstResponder()
    }
    
    func setDatePicker() {
        datePicker.datePickerMode = .dateAndTime
        self.inputView = datePicker
    }
    
}

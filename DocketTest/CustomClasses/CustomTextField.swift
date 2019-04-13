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
        self.layer.borderColor = UIColor.mainColor.cgColor
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
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancelAction))
        if isDatePicker {
            done.action = #selector(self.datePickerDoneAction)
            setDatePicker()
        }
        done.tintColor = UIColor.mainColor
        cancel.tintColor = UIColor.mainColor
        let items = [cancel, flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
    @objc func cancelAction() {
        self.resignFirstResponder()
        self.text = ""
    }
    
    //MARK: - Date Picker Setup
    @objc func datePickerDoneAction() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm a"
        self.text = formatter.string(from: datePicker.date)
        self.resignFirstResponder()
    }
    
    func setDatePicker() {
        datePicker.datePickerMode = .dateAndTime
        self.inputView = datePicker
    }
    
    func moveSuperViewUp() {
        UIView.animate(withDuration: 0.4, delay: 0.3, options: .curveEaseInOut, animations: {
            self.superview!.frame.origin.y = self.superview!.frame.origin.y / 2
//            self.superview?.center.y = self.superview!.center.y / 2
        }, completion: nil)
    }
    
    func moveSuperViewDown() {
        if superview!.frame.origin.y != 0 {
            UIView.animate(withDuration: 0.2) {
                self.superview!.frame.origin.y = 0
            }
        }
    }
}

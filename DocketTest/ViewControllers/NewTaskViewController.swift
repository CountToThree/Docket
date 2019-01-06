//
//  NewTaskViewController.swift
//  DocketTest
//
//  Created by Max on 29.11.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

class NewTaskViewController: UIViewController {
    
    @IBOutlet weak var taskNameTF: CustomTextField!
    @IBOutlet weak var taskInfoTF: CustomTextField!
    @IBOutlet weak var prioritySlider: UISlider!
    @IBOutlet weak var reminderTF: CustomTextField!
    @IBOutlet weak var sliderLabel: UILabel!
    
    var taskTitle = ""
    var taskInfo = ""
    var priorityValue = 5 as Float
    var reminderDate = ""
    var itemID = ""
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var notID: String?
    var editTask: Bool!
    var parentID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskNameTF.setup()
        taskInfoTF.setup()
        reminderTF.setup(datePicker: true)
        setValues()
    }
    
    func setValues() {
        taskNameTF.text = taskTitle
        taskInfoTF.text = taskInfo
        prioritySlider.value = priorityValue
        setSlider()
        reminderTF.text = reminderDate
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        setNotification()
        saveTask()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
       setSlider()
        
    }
    
    func setSlider() {
        var prValue = prioritySlider.value
        prValue = roundf(prValue)
        prioritySlider.value = prValue
        
        switch prValue {
        case 0:
            sliderLabel.text = "Very Low"
        case 1, 2, 3:
            sliderLabel.text = "Low"
        case 4, 5, 6:
            sliderLabel.text = "Normal"
        case 7, 8, 9:
            sliderLabel.text = "High"
        case 10:
            sliderLabel.text = "Very High"
        default:
            sliderLabel.text = "Normal"
        }
    }
    
    func setNotification() {
        if reminderTF.text != "" {
            print("Notification")
            
            //MARK: Notification Content
            let content = UNMutableNotificationContent()
            content.title = "\(taskNameTF.text ?? "")"
            content.body = "\(taskInfoTF.text ?? "")"
            content.sound = UNNotificationSound.default
            content.badge = 1
            
            //MARK: Notification Trigger
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderTF.datePicker.date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
            //MARK: Notification Request
            notID = UUID().uuidString
            let request = UNNotificationRequest(identifier: notID!, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }
    
    func saveTask() {
        var newTask = TaskItem(title: taskNameTF.text!, desc: taskInfoTF.text, done: false, priority: prioritySlider.value, notificationID: notID, notificationDate: reminderTF.text, taskID: itemID)
        let userID = Auth.auth().currentUser?.uid ?? ""
        let taskDB = Database.database().reference().child("tasks/\(userID)/\(parentID)")

        if !editTask {
            taskDB.childByAutoId().setValue(newTask.toAnyObject()) {
                (error, ref) in
                if error != nil {
                    print(error ?? "")
                } else {
                    print("Message saved successfully")
                }
            }
        } else {
            print("Update Values")
            newTask.taskID = itemID
            let childUpdates = ["tasks/\(userID)/\(parentID)/\(itemID)/": newTask.toAnyObject()]
            Database.database().reference().updateChildValues(childUpdates)
        }
        
    }
    
    @IBAction func reminderEditingBegin(_ sender: Any) {
        reminderTF.moveSuperViewUp()
    }
    
    @IBAction func reminderEditingEnd(_ sender: Any) {
        reminderTF.moveSuperViewDown()
    }
}

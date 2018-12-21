//
//  NewTaskViewController.swift
//  DocketTest
//
//  Created by Max on 29.11.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit
import UserNotifications

class NewTaskViewController: UIViewController {
    
    @IBOutlet weak var taskNameTF: CustomTextField!
    @IBOutlet weak var taskInfoTF: CustomTextField!
    @IBOutlet weak var prioritySlider: UISlider!
    @IBOutlet weak var reminderTF: CustomTextField!
    
    var taskTitle = ""
    var taskInfo = ""
    var priorityValue = 5.0 as Float
    var reminderDate = ""
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var notID: String?
    var taskToDelete: Int?
    
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
        reminderTF.text = reminderDate
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        setNotification()
        NotificationCenter.default.post(name: .saveNewTaskItems, object: self)
        navigationController?.popViewController(animated: true)
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
}

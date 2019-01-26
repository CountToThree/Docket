//
//  NotificationNameExtension.swift
//  DocketTest
//
//  Created by Max on 28.11.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension Notification.Name {
    static let saveNewListName = Notification.Name("saveNewListName")
    static let saveNewTaskItems = Notification.Name("saveNewTaskItems")
    static let saveData = Notification.Name("saveData")
    static let editTaskData = Notification.Name("editTaskData")
    static let toggleSideMenu = Notification.Name("toggleSideMenu")
    static let showUpgrade = Notification.Name("showUpgrade")
    static let showProfile = Notification.Name("showProfile")
    static let showCalendar = Notification.Name("showCalendar")
    static let showContact = Notification.Name("showContact")
    static let logOut = Notification.Name("logOut")
    static let updateFirstName = Notification.Name("updateFirstName")
    static let updateListInfo = Notification.Name("updateListInfo")
    
}

extension UIColor {
    static let lightGreen = UIColor(red: 165/255, green: 209/255, blue: 176/255, alpha: 1.0)
    static let lightRed = UIColor(red: 249/255, green: 122/255, blue: 122/255, alpha: 1.0)
    static let darkGreen = UIColor(red: 140/255, green: 193/255, blue: 149/255, alpha: 1.0)
    
    
    static func setColor(at row: String) -> UIColor {
        switch row {
        case "None":
            return UIColor.white
        case "Blue":
            return UIColor(red: 89/255, green: 166/255, blue: 255/255, alpha: 1.0)
        case "Red":
            return UIColor(red: 255/255, green: 76/255, blue: 76/255, alpha: 1.0)
        case "Yellow":
            return UIColor(red: 226/255, green: 215/255, blue: 0/255, alpha: 1.0)
        case "Green":
            return UIColor.lightGreen
        case "Black":
            return UIColor.black
        default:
            return UIColor.lightGreen
        }
    }
}

extension FirebaseApp {
    static func getTaskData(from snap: DataSnapshot) -> TaskItem? {
        let snapshotValue = snap.value as? [String: AnyObject] ?? [:]
        guard let taskTitle = snapshotValue["title"] as? String else { return nil }
        guard let taskDesc = snapshotValue["description"] as? String else { return nil }
        guard let taskDone = snapshotValue["completed"] as? Bool else { return nil }
        guard let taskPriority = snapshotValue["priority"] as? Float else { return nil }
        let taskNotID: String?
        let taskNotDate: String?
        let calendarDate: String?
        
        if let notID = snapshotValue["notificationID"] as? String {
            taskNotID = notID
        } else {
            taskNotID = nil
        }
        
        if let notDate = snapshotValue["notificationDate"] as? String {
            taskNotDate = notDate
        } else {
            taskNotDate = nil
        }
        
        if let calDate = snapshotValue["calendarDate"] as? String {
            calendarDate = calDate
        } else {
            calendarDate = nil
        }
        
        let id = snap.key
        
        let task = TaskItem(title: taskTitle, desc: taskDesc, done: taskDone, priority: taskPriority, notificationID: taskNotID, notificationDate: taskNotDate, calendarDate: calendarDate, taskID: id)
        return task
    }
    
    static func getListData(from snap: DataSnapshot) -> ListItem? {
        let snapshotValue = snap.value as? [String: AnyObject] ?? [:]
        
        guard let listTitle = snapshotValue["name"] as? String else { return nil }
        guard let listID = snapshotValue["id"] as? String else { return nil }
        guard let color = snapshotValue["color"] as? String else { return nil }
        guard let info = snapshotValue["info"] as? String else { return nil }
        return ListItem(name: listTitle, color: color, infoText: info, listID: listID)
    }
    
    static func getCalendarData(from snap: DataSnapshot) -> CalendarItem? {
        //let snapshotValue = snap.value as? [String: AnyObject] ?? [:]
        return nil
       // guard let title = snapshotValue[""]
    }
}

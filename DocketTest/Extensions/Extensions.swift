//
//  NotificationNameExtension.swift
//  DocketTest
//
//  Created by Max on 28.11.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import Foundation
import UIKit

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
            return UIColor(red: 247/255, green: 255/255, blue: 107/255, alpha: 1.0)
        case "Green":
            return UIColor.lightGreen
        case "Black":
            return UIColor.black
        default:
            return UIColor.lightGreen
        }
    }
}



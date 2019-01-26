//
//  TaskItem.swift
//  DocketTest
//
//  Created by Max on 27.12.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit

struct TaskItem {
    var title: String
    var desc: String?
    var done: Bool
    var priority: Float
    var notificationID: String?
    var notificationDate: String?
    var calendarDate: String?
    var taskID: String
    
    func toAnyObject() -> Any {
        return ["title": title, "description": desc as Any, "completed": done, "priority": priority, "notificationID": notificationID as Any, "notificationDate": notificationDate as Any, "calendarDate": calendarDate as Any]
    }
}

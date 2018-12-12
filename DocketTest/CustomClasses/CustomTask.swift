//
//  CustomTask.swift
//  DocketTest
//
//  Created by Max on 02.12.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import Foundation

struct CustomTask: Codable {
    
    var taskTitle: String
    var taskInfo: String
    var priority: Int
    var completed: Bool
    var creationDate: Date
}

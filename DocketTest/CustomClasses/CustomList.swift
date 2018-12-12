//
//  CustomList.swift
//  DocketTest
//
//  Created by Max on 02.12.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import Foundation

struct CustomList: Codable {
    
    var listTitle: String
    var tasks = [CustomTask]()
    
}

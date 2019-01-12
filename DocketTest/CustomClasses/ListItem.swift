//
//  ListItem.swift
//  DocketTest
//
//  Created by Max on 27.12.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit

struct ListItem {
    var name: String
    var color: String
    var listID: String
    
    func toAnyObject() -> Any {
        return ["name": name, "color": color, "id": listID]
    }
}

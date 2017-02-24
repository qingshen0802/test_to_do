//
//  ToDoModel.swift
//  ToDo
//
//  Created by Admin on 2/24/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoModel: Object {
    dynamic var id = 0
    dynamic var name: String!
    dynamic var content: String!
    dynamic var date: Date!
    dynamic var finished = false
}

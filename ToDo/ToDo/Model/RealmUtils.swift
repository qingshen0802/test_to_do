//
//  RealmUtils.swift
//  ToDo
//
//  Created by Admin on 2/24/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import RealmSwift


class RealmUtils{
    
    static let sharedUtil = RealmUtils()
    
    let realm = try! Realm()
    
    func readAllTasks() -> Results<ToDoModel> {
        return realm.objects(ToDoModel.self)
    }
    
    func addNewTask(task: ToDoModel) {
        try! realm.write {
            task.id = incrementID()
            realm.add(task)
        }
    }
    
    func searchTasks(name: String) -> Results<ToDoModel> {
        return realm.objects(ToDoModel.self).filter("name CONTAINS '\(name)' AND finished = false")
    }
    
    func sortByDate() -> Results<ToDoModel> {
        return realm.objects(ToDoModel.self).sorted(byKeyPath: "date")
    }
    
    func sortByName() -> Results<ToDoModel> {
        return realm.objects(ToDoModel.self).sorted(byKeyPath: "name")
    }
    
    func updateTask(task: ToDoModel) {
        let temp = realm.objects(ToDoModel.self).filter("id == \(task.id)").first
        try! realm.write {
            temp?.name = task.name
            temp?.content = task.content
            temp?.date = task.date
        }
    }
    
    func markAsDone(task: ToDoModel) {
        let temp = realm.objects(ToDoModel.self).filter("id == \(task.id)").first
        try! realm.write {
            temp?.finished = true
        }
    }
    
    func removeTask(task: ToDoModel) {
        try! realm.write {
            realm.delete(task)
        }
    }
    
    func removeAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func incrementID() -> Int {
        return (realm.objects(ToDoModel.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}

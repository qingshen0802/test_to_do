//
//  DetailViewController.swift
//  ToDo
//
//  Created by Admin on 2/24/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var txtDate: CustomTextField!
    @IBOutlet weak var txtName: CustomTextField!
    @IBOutlet weak var txtContent: CustomTextView!
    
    var newTask: ToDoModel!
    var editTask: ToDoModel!
    
    var edit = false
    let df = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtDate.setTextFieldType(textFieldType: .Date)
        txtName.setTextFieldType(textFieldType: .Normal)
        txtName.setTextFieldEnableEmpty(enable: false)
        
        df.dateFormat = "dd MMM yyyy"
        
        if edit {
            txtDate.text = df.string(from: editTask.date)
            txtName.text = editTask.name
            txtContent.text = editTask.content
        }
    }

    @IBAction func tapSave(_ sender: UIButton) {
        if txtName.checkValid() {
            newTask = ToDoModel()
            newTask.name = txtName.text!
            newTask.content = txtContent.text
            newTask.date = df.date(from: txtDate.text!)
            if edit {
                newTask.id = editTask.id
                RealmUtils.sharedUtil.updateTask(task: newTask)
            } else {
                RealmUtils.sharedUtil.addNewTask(task: newTask)
            }
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func tapCancel(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}

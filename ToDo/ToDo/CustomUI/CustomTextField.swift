//
//  CustomTextField.swift
//  ToDo
//
//  Created by Admin on 2/24/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

enum TextFieldType: Int {
    case Normal, Date
}

class CustomTextField: UITextField, UITextFieldDelegate {
    
    var enableEmpty: Bool = true
    var type: TextFieldType = .Normal
    var datePicker = UIDatePicker()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    func initialize() {
        self.delegate = self
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor(red: 241.0 / 255.0, green: 241.0 / 255.0, blue: 241.0 / 255.0, alpha: 1.0).cgColor
        NotificationCenter.default.addObserver(self, selector: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
    }
    
    func setTextFieldEnableEmpty(enable: Bool) {
        self.enableEmpty = enable
    }
    
    func setTextFieldType(textFieldType: TextFieldType) {
        type = textFieldType
        if type == .Date
        {
            let minDate = Date()
            let df = DateFormatter()
            df.dateFormat = "dd MMM yyyy"
            self.text = df.string(from: minDate)
            datePicker.datePickerMode = UIDatePickerMode.date
            datePicker.addTarget(self, action: #selector(CustomTextField.datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
            datePicker.minimumDate = minDate
            self.inputView = datePicker
            self.enableEmpty = true
        }
    }
    
    func setValid(valid:Bool) {
        if valid != true {
            self.layer.borderColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0).cgColor
        } else {
            self.layer.borderColor = UIColor(red: 241.0 / 255.0, green: 241.0 / 255.0, blue: 241.0 / 255.0, alpha: 1.0).cgColor
        }
    }
    
    func checkValid() -> Bool {
        if type == .Normal && !enableEmpty && self.text!.isEmpty {
            self.setValid(valid: false)
            return false
        }
        self.setValid(valid: true)
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        _ = checkValid()
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        let df = DateFormatter()
        df.dateFormat = "dd MMM yyyy"
        self.text = df.string(from: datePicker.date)
    }
}


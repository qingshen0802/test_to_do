//
//  CustomTextView.swift
//  ToDo
//
//  Created by Admin on 2/24/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

class CustomTextView: UITextView {
    var content = "Content"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    func initialize() {
        let layer = self.layer as CALayer
        layer.cornerRadius = 4.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(red: 241.0 / 255.0, green: 241.0 / 255.0, blue: 241.0 / 255.0, alpha: 1.0).cgColor
        NotificationCenter.default.addObserver(self, selector: #selector(UITextViewDelegate.textViewDidBeginEditing(_:)), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(UITextViewDelegate.textViewDidEndEditing(_:)), name: NSNotification.Name.UITextViewTextDidEndEditing, object: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if content == self.text {
            self.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.text == "" {
            self.text = content
        }
    }
}

//
//  ToDoCell.swift
//  ToDo
//
//  Created by Admin on 2/24/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ToDoCell: UITableViewCell {

    @IBOutlet weak var labelToDoName: UILabel!
    @IBOutlet weak var labelToDoDate: UILabel!
    let df = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setModel(todo: ToDoModel) {
        df.dateFormat = "dd MMM yyyy"
        self.labelToDoName.text = todo.name
        self.labelToDoDate.text = df.string(from: todo.date)
    }
}

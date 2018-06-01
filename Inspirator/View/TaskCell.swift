//
//  TaskCell.swift
//  Inspirator
//
//  Created by Георгий Фесенко on 16.05.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var taskNameLbl: UILabel!
    @IBOutlet weak var deadlineLbl: UILabel!
    
    func configureCell(model: TaskModel) {
        taskNameLbl.text = model.name
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        deadlineLbl.text = formatter.string(from: model.deadline)
    }

}

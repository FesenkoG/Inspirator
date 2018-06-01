//
//  TaskViewController.swift
//  Inspirator
//
//  Created by Георгий Фесенко on 16.05.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var taskNameLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    @IBOutlet weak var deadlineLbl: UILabel!
    
    @IBOutlet weak var detailedDescriptionTextView: UITextView!
    @IBOutlet weak var daysLeftLbl: UILabel!
    
    var model: TaskModel?
    var dataService: CoreDataStack?
    var remoteDataService: DataService?
    
    override func viewDidLoad() {
        tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
        guard let cost = model?.cost else { return }
        guard let deadline = model?.deadline else { return }
        taskNameLbl.text = model?.name
        costLbl.text = "Cost of the task is: " + String(describing: cost)
        deadlineLbl.text = "Deadline: " + formatDate(date: deadline)
        daysLeftLbl.text = "Days left: " + getDaysLeft(date: deadline)
        detailedDescriptionTextView.text = model?.description
        
    }

    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
    
    func getDaysLeft(date: Date) -> String {
        let calendar = NSCalendar.current
        
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        guard let days = components.day, days >= 0 else { return "" }
        
        return String(describing: days)
    }
    
    @IBAction func finishTask(_ sender: Any) {
        guard let name = model?.name else { return }
        guard let points = model?.cost else { return }
        remoteDataService?.updateUserData(withPoints: Int(points)) { }
        dataService?.deleteTask(withName: name)
        self.navigationController?.popViewController(animated: true)
        
    }
    

}

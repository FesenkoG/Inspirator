//
//  CreateTaskViewController.swift
//  Inspirator
//
//  Created by Георгий Фесенко on 16.05.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit
import UserNotifications


class CreateTaskViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var desctiprionTextView: UITextView!
    
    private var dataService: CoreDataStack
    var remoteDataService: DataService
    
    init(dataService: CoreDataStack, remoteDataService: DataService) {
        self.dataService = dataService
        self.remoteDataService = remoteDataService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        desctiprionTextView.delegate = self
    }
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func addTask(_ sender: Any) {
        
        if let title = titleTextField.text, let costStr = costTextField.text, let timeStr = timeTextField.text, let description = desctiprionTextView.text, !title.isEmpty, !costStr.isEmpty, !timeStr.isEmpty, !description.isEmpty, let days = Int(timeStr), let cost = Int32(costStr) {
            let deadline = Date(timeIntervalSinceNow: TimeInterval(days * 24 * 60 * 60 + 10))
            let model = TaskModel(name: title, description: description, deadline: deadline, cost: cost)
            //Save to core data
            dataService.addTask(task: model)
            //Save to Firebase
            remoteDataService.uploadTask(model, completion: {
                self.addLocalNotification(withTitle: "Oups!", andBody: "You have expired your task named \(model.name)", andIdentifier: "task\(model.name)IsExpired", forTimeInSecondsSinceNow: Double(days * 24 * 60 * 60 + 10))
                self.addLocalNotification(withTitle: "Hurry up!", andBody: "You have only one hour left to finish the task \"\(model.name)\"", andIdentifier: "oneHourLeftToFinishTask\(model.name)", forTimeInSecondsSinceNow: Double(days * 24 * 60 * 60 + 10 - 60 * 60))
                self.dismiss(animated: true, completion: nil)
            })
        }
        
    }
    
    func addLocalNotification(withTitle title: String, andBody body: String, andIdentifier identifier:String,  forTimeInSecondsSinceNow timeInterval: Double) {
        if timeInterval > 0 {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterval), repeats: false)
            let requestIdentifier = identifier
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                print(error ?? "everything is all right!")
            })
        }
    }
}

extension CreateTaskViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

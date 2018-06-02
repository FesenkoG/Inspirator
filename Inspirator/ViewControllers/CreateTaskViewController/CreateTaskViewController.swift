//
//  CreateTaskViewController.swift
//  Inspirator
//
//  Created by Георгий Фесенко on 16.05.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

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
            let deadline = Date(timeIntervalSinceNow: TimeInterval(days * 24 * 60 * 60))
            let model = TaskModel(name: title, description: description, deadline: deadline, cost: cost)
            //Save to core data
            dataService.addTask(task: model)
            //Save to Firebase
            remoteDataService.uploadTask(model, completion: {
                self.dismiss(animated: true, completion: nil)
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

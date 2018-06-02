//
//  TasksViewController.swift
//  Inspirator
//
//  Created by Георгий Фесенко on 16.05.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var dataService = CoreDataStack()
    lazy var remoteDataService = DataService()
    var tasks = [TaskModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        tasks = dataService.getTasks()
        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        checkTasks() { (task) in
            let taskDeleted = UIAlertController(title: "Task \"\(task.name)\" has been removed", message: "You have lost \(task.cost) points", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            taskDeleted.addAction(action)
            self.present(taskDeleted, animated: true)
        }
    }
    
    func checkTasks(completion: @escaping (TaskModel) -> Void ) {
        tasks = dataService.getTasks()
        for task in tasks {
            if task.deadline < Date() {
                remoteDataService.updateUserData(withPoints: -Int(task.cost), completion: nil)
                completion(task)
                dataService.deleteTask(withName: task.name)
                remoteDataService.removeTask(task) {
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    @IBAction func addTask(_ sender: Any) {
        let vc = CreateTaskViewController(dataService: dataService, remoteDataService: remoteDataService)
        
        self.present(vc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TaskViewController {
            guard let model = sender as? TaskModel else { return }
            vc.navigationItem.title = model.name
            vc.model = model
            vc.dataService = dataService
            vc.remoteDataService = remoteDataService
        }
        
    }
}

extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "ToTask", sender: tasks[indexPath.row] as Any)
    }
}

extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as? TaskCell else { return UITableViewCell() }
        cell.configureCell(model: tasks[indexPath.row])
        return cell
    }
    
}

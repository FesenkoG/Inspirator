//
//  CoreDataStack.swift
//  Inspirator
//
//  Created by Георгий Фесенко on 21.05.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    lazy var container: NSPersistentContainer = NSPersistentContainer(name: "CoreDataModel")
    init() {
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
    }
    private func save(){
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func addTask(task: TaskModel) {
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: "Task", into: container.viewContext) as? Task else { return }
        entity.title = task.name
        entity.cost = task.cost
        entity.descr = task.description
        entity.time = task.deadline
        
        self.save()
    }
    
    func getTasks() -> [TaskModel] {
        var tasks = [TaskModel]()
        let requestTasks: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "time", ascending: true)
        requestTasks.sortDescriptors = [sortDescriptor]
        do {
            let results = try container.viewContext.fetch(requestTasks)
            results.forEach { (task) in
                let bubble = TaskModel(name: task.title!, description: task.descr!, deadline: task.time!, cost: task.cost)
                tasks.append(bubble)
            }
        } catch {
            print(error)
        }
        
        return tasks
    }
    
    func deleteTask(withName name: String) {
        let requestTaskWithName: NSFetchRequest<Task> = Task.fetchRequest()
        requestTaskWithName.predicate = NSPredicate(format: "title == %@", name)
        do {
            if let results = try container.viewContext.fetch(requestTaskWithName).first {
                container.viewContext.delete(results)
                try container.viewContext.save()
            }
            
        } catch {
            print(error)
        }
    }
    
    func deleteAllTasks() {
        let requestTaskWithName: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            if let results = try container.viewContext.fetch(requestTaskWithName).first {
                container.viewContext.delete(results)
                try container.viewContext.save()
            }
            
        } catch {
            print(error)
        }
    }
}

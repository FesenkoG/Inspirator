//
//  DataService.swift
//  Inspirator
//
//  Created by Георгий Фесенко on 26.05.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation
import Firebase

let dbBase = Database.database().reference()

class DataService {
    private let refUsers = dbBase.child("users")
    private let refTasks = dbBase.child("tasks")
    
    //USERS
    func createDBUser(uid: String, userData: [String: Any]) {
        refUsers.child(uid).updateChildValues(userData)
    }
    
    func getUserData(completionHandler: @escaping (UserData) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        refUsers.child(uid).observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let email = dataSnapshot.childSnapshot(forPath: "email").value as? String else { return }
            guard let points = dataSnapshot.childSnapshot(forPath: "points").value as? Int else { return }
            let data = UserData(email: email, points: points)
            completionHandler(data)
            
        }
    }
    
    func updateUserData(withPoints points: Int, completion: (() -> Void)?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        getUserData { (data) in
            let newPoints = data.points + points
            let dataToSend: [String: Any] = ["email": data.email, "points": newPoints]
            self.refUsers.child(uid).updateChildValues(dataToSend)
            completion?()
        }
    }
    func getAllUsers(completionHandler: @escaping ([ParticipantModel]) -> Void) {
        var users = [ParticipantModel]()
        refUsers.observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let snapshot = dataSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in snapshot {
                guard let points = user.childSnapshot(forPath: "points").value as? Int else { return }
                guard let email = user.childSnapshot(forPath: "email").value as? String else { return }
                
                users.append(ParticipantModel(name: email, points: points))
            }
            completionHandler(users)
        }
    }
    //TASKS
    func uploadTask(_ task: TaskModel, completion: (() -> ())?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let interval: Double = task.deadline.timeIntervalSince1970
        let dataToSend: [String: Any] = ["name":task.name, "descr":task.description, "cost":task.cost, "deadline":interval, "userId": uid]
        refTasks.childByAutoId().updateChildValues(dataToSend)
        completion?()
    }
        //TODO : CREATE THIS METHOD
    func removeTask(_ task: TaskModel, completion: ((Bool) -> Void)?) {
        
    }
    
    func getTasks(handler: @escaping ([TaskModel]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var tasks = [TaskModel]()
        refTasks.observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let dataSnapshot = dataSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for task in dataSnapshot {
                guard let userId = task.childSnapshot(forPath: "userId").value as? String else { return }
                if userId == uid {
                    guard let name = task.childSnapshot(forPath: "name").value as? String else { return }
                    guard let descr = task.childSnapshot(forPath: "descr").value as? String else { return }
                    guard let cost = task.childSnapshot(forPath: "cost").value as? Int32 else { return }
                    guard let deadline = task.childSnapshot(forPath: "deadline").value as? Double else { return }
                    
                    let taskModel = TaskModel(name: name, description: descr, deadline: Date(timeIntervalSince1970: deadline), cost: cost)
                    tasks.append(taskModel)
                }
            }
            handler(tasks)
        }
    }
    
}

struct UserData {
    var email: String
    var points: Int
}

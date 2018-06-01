//
//  AuthService.swift
//  Inspirator
//
//  Created by Георгий Фесенко on 14.05.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation
import Firebase

protocol IAuthService {
    func createUser(withEmail email: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void)
    func loginUser(withEmail email: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void)
    func checkAuth(completinHandler: @escaping (Bool) -> Void)
    func logoutCurrentUser(completionHandler: @escaping (Bool) -> Void)
    
}
class AuthService: IAuthService {
    
    let dataService = DataService()
    
    func createUser(withEmail email: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            if error == nil {
                guard let user = data?.user else { return }
                guard let email = user.email else { return }
                let userData = ["email": email, "points": 1000] as [String : Any]
                self.dataService.createDBUser(uid: user.uid, userData: userData)
                
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
            }
        }
    }
    
    func loginUser(withEmail email: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
            if error == nil {
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
            }
        }
    }
    
    func checkAuth(completinHandler: @escaping (Bool)-> Void) {
        if Auth.auth().currentUser == nil {
            completinHandler(false)
        } else {
            completinHandler(true)
        }
    }
    
    func logoutCurrentUser(completionHandler: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completionHandler(true)
        } catch {
            completionHandler(false)
            print(error)
        }
    }
}

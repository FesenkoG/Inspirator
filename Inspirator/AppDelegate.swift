//
//  AppDelegate.swift
//  Inspirator
//
//  Created by Георгий Фесенко on 14.05.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            print(error ?? "everyting is all right")
        }
        return true
    }

}


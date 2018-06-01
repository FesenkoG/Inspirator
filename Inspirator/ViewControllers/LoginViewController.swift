//
//  ViewController.swift
//  Inspirator
//
//  Created by Георгий Фесенко on 14.05.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    lazy var authService: IAuthService = AuthService()
    lazy var remoteDataService: DataService = DataService()
    lazy var dataService = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authService.checkAuth { (userLoggedIn) in
            if userLoggedIn {
                self.performSegue(withIdentifier: "toTabBar", sender: nil)
            } else {
                print("sorry")
            }
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let keyboardHeight = keyboardFrame.height
        let newFrame = CGRect(x: 0, y: -keyboardHeight, width: self.view.frame.width, height: self.view.frame.height)
        UIView.animate(withDuration: animationDurarion) {
            self.view.frame = newFrame
        }
        
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        var userInfo = notification.userInfo!
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let newFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        UIView.animate(withDuration: animationDurarion) {
            self.view.frame = newFrame
        }
    }
    
    func loadData() {
        
    }
    
    @IBAction func login(_ sender: Any) {
        if let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty {
            authService.loginUser(withEmail: email, password: password) { (success, error) in
                if success {
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                } else {
                    print(error?.localizedDescription as Any)
                }
            }
        }
    }
    
    @IBAction func createAccount(_ sender: Any) {
        self.performSegue(withIdentifier: "toCreateAccount", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CreateAccountViewController {
            vc.authService = authService
        } else if let vc = segue.destination as? UITabBarController {
            vc.selectedIndex = 1
        }
    }
    
    
    
}


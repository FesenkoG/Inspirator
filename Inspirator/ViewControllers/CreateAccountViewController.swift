//
//  CreateAccountViewController.swift
//  Inspirator
//
//  Created by Георгий Фесенко on 14.05.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var authService: IAuthService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
    
    
    @IBAction func register(_ sender: Any) {
        if let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty, let confirmation = confirmPasswordTextField.text, password == confirmation {
            authService?.createUser(withEmail: email, password: password, completionHandler: { (success, error) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print(error?.localizedDescription as Any)
                }
            })
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

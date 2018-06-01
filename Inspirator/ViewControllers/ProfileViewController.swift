//
//  ProfileViewController.swift
//  Inspirator
//
//  Created by Георгий Фесенко on 21.05.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var pointsLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberOfAccomplishedTasksLbl: UILabel!
    @IBOutlet weak var numberOfFailedTasksLbl: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var authService: IAuthService = AuthService()
    var remoteDataService = DataService()
    var participants = [ParticipantModel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spinner.startAnimating()
        spinner.isHidden = false
        //Downloading data from the server
        remoteDataService.getAllUsers { (users) in
            self.participants = users
            self.participants.sort(by: {$0.points > $1.points})
            self.remoteDataService.getUserData(completionHandler: { (userData) in
                self.pointsLbl.text = String(describing: userData.points)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                }
            })
        }
        
    }
    
    @IBAction func logout(_ sender: Any) {
        authService.logoutCurrentUser(completionHandler: { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        })
        
        
    }
    
    @IBAction func uploadData(_ sender: Any) {
        
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell") as? RatingCell else { return UITableViewCell() }
        cell.configureCell(participant: participants[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

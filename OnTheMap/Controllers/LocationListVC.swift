//
//  LocationListVC.swift
//  On The Map
//
//  Created by 🍑 on 14/11/2019.
//  Copyright © 2019 udacity. All rights reserved.
//

import UIKit

class LocationListVC: UITableViewController {
    
    //MARK:- Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        DispatchQueue.main.async {
            self.loadList()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        DispatchQueue.main.async {
            self.loadList()
        }
    }
    //MARK:- IBActions
    @IBAction func addLocation(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "add", sender: nil)
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        DispatchQueue.main.async {
            self.loadList()
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        DispatchQueue.main.async {
            OTMClient.logout(completion: self.handleLogoutRequest(success:error:))
        }
    }
    
    //MARK:- Handling logout request
    func handleLogoutRequest(success: Bool, error: Error?) {
        if success {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            showAlertMessage("Logout Failed", "Check your network")
        }
    }
    
    //MARK:- Handling getting students locations request
    func loadList() {
        OTMClient.getStudentLocation { (studentsLocations, errorMsg, error) in
            if error == nil {
                DispatchQueue.main.async {
                    StudentsLocations.studentsLocations = studentsLocations
                    self.tableView.reloadData() //if no error occurs the data from the model will load in table view
                }
            } else {
                self.showAlertMessage("Error", errorMsg!)
            }
        }
    }
    //MARK:- TableView delegates
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsLocations.studentsLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        let row = StudentsLocations.studentsLocations[indexPath.row]
        cell.textLabel?.text = "\(row.firstName) \(row.lastName)"
        cell.detailTextLabel?.text = "\(row.mapString)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellUrl = URL(string: StudentsLocations.studentsLocations[indexPath.row].mediaURL) , UIApplication.shared.canOpenURL(cellUrl) {
            UIApplication.shared.open(cellUrl, options: [:], completionHandler: nil)
        }
        
    }
    
    
    
    
    

    
}

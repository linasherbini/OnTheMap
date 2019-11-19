//
//  ViewController.swift
//  On The Map
//
//  Created by 🍑 on 08/11/2019.
//  Copyright © 2019 udacity. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK:- Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        emailTextField.text = ""
        passwordTextField.text = ""
        activityIndicator.stopAnimating()
    }
    
    //MARK:- IBActions
    @IBAction func signup(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func login(_ sender: Any) {
        DispatchQueue.main.async {
            OTMClient.login(email: self.emailTextField.text!, password: self.passwordTextField.text!, completion: self.handleLoginRequest(success:error:))
        }
    }
    
    //MARK:- Handling requests & responses
    func handleLoginRequest(success: Bool, error: Error?) {
        if success {
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(identifier: "tabController") as! UITabBarController
                vc.modalPresentationStyle = .fullScreen
                self.show(vc, sender: nil)
                self.activityIndicator.startAnimating()
            }
        } else {
            self.showAlertMessage("Login Failed", error!.localizedDescription)
            self.activityIndicator.stopAnimating()
        }
    }
    
}


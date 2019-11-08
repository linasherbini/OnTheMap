//
//  ViewController.swift
//  OnTheMap
//
//  Created by 🍑 on 25/10/2019.
//  Copyright © 2019 udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let loginTextFieldDelegate = LoginTextFieldDelegate()

    override func viewDidLoad() {
        emailTextField.delegate = loginTextFieldDelegate
        passwordTextField.delegate = loginTextFieldDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    @IBAction func login(_ sender: Any) {
        DispatchQueue.main.async {
            OTMClient.login(email: self.emailTextField.text!, password: self.passwordTextField.text!, completion: self.handleLoginResponse(success:error:))
        }
        
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                self.setLoggingIn(true)
            }
        } else {
            DispatchQueue.main.async {
                self.showAlertMessage()
                self.setLoggingIn(false)
            }
            
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func showAlertMessage() {
        let alert = UIAlertController(title: "Please try again", message: "The email and/or password you entered are incorrect. Please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}


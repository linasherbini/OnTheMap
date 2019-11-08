//
//  TextFieldDelegate.swift
//  OnTheMap
//
//  Created by 🍑 on 06/11/2019.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation
import UIKit

class LoginTextFieldDelegate: UIViewController, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text == "Email" || textField.text == "Password" {
            textField.text = ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true;
    }
}

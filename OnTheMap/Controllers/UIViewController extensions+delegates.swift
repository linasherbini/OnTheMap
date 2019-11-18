//
//  TextFieldDelegate.swift
//  On The Map
//
//  Created by 🍑 on 15/11/2019.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}

extension UIViewController {
    func showAlertMessage(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

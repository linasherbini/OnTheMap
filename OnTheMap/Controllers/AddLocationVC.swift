//
//  NewLocationVC.swift
//  On The Map
//
//  Created by 🍑 on 13/11/2019.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AddLocationVC: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    //MARK:- Life cycles
    override func viewDidLoad() {
        locationTextField.delegate = self
        urlTextField.delegate = self
        super.viewDidLoad()
    }
    //MARK: IBActions
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findClicked(_ sender: UIButton) {
        guard let locationString = locationTextField.text , let urlString = urlTextField.text , locationString != "" || urlString != "" else {
            showAlertMessage("Please try again", "Please fill in the empty fields")
            return
        }
        //initiating a new studentLocation object
        let studentLocation = StudentLocation(objectId: OTMClient.Auth.sessionId,
        uniqueKey: OTMClient.Auth.key,
        firstName: OTMClient.Auth.firstName,
        lastName: OTMClient.Auth.lastName,
        mapString: locationString,
        mediaURL: urlString,
        latitude: 0,
        longitude: 0
        )
        findLocation(studentLocation)
    }
    
    func findLocation(_ location: StudentLocation) {
        activityIndicator.startAnimating()
        //turns an address string into coordinates
        CLGeocoder().geocodeAddressString(location.mapString) { (placemark, error) in
            guard error == nil else {
                self.activityIndicator.stopAnimating()
                self.showAlertMessage("Please try again", "couldn't find the location")
                return
            }
            let coordinates = placemark?.first?.location?.coordinate
            var studentLocation = location
            studentLocation.longitude = coordinates!.longitude
            studentLocation.latitude = coordinates!.latitude
            self.activityIndicator.stopAnimating()
            //sending studentLocation object to next view
            self.performSegue(withIdentifier: "confirm", sender: studentLocation)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirm" {
            let vc = segue.destination as! ConfirmLocationVC
            vc.location = (sender as! StudentLocation) //sending studentLocation object to next view
        }
    }
 
}
    
    
    
    
    

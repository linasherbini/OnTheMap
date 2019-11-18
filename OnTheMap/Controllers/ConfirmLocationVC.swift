//
//  ConfirmLocationVC.swift
//  OnTheMap
//
//  Created by 🍑 on 16/11/2019.
//  Copyright © 2019 udacity. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var location: StudentLocation?
    
    //MARK:- Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.setAnnotations()
        }
    }
    //MARK:- IBAction
    @IBAction func cancel(_sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: Any) {
        DispatchQueue.main.async {
            OTMClient.postStudentLocation(self.location!, completion: self.postStudentHandler(errorMsg:error:))
        }
    }
    //MARK:- Handling posting student location response
    func postStudentHandler(errorMsg: String?, error: Error?) {
        DispatchQueue.main.async {
            if error == nil { self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            } else {
                self.showAlertMessage("Submit failed", errorMsg!)
            }
        }
    }
    //MARK:- Setting the new added annotation
    func setAnnotations() {
        var annotations = [MKPointAnnotation]()
        guard let newLocation = location else { return }
        let lat = newLocation.latitude
        let long = newLocation.longitude
        let coordination = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let firstName = OTMClient.Auth.firstName
        let lastName = OTMClient.Auth.lastName
        let mediaURL = newLocation.mediaURL
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordination
        annotation.title = "\(firstName) \(lastName)"
        annotation.subtitle = mediaURL
        let region = MKCoordinateRegion(center: coordination, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)) //zooms on area
        mapView.setRegion(region, animated: true)
        annotations.append(annotation)
        self.mapView.addAnnotations(annotations)
        activityIndicator.stopAnimating()
    }
    
    //MARK:- MapView delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }

}

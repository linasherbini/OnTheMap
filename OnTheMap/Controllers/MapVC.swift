//
//  MapVC.swift
//  On The Map
//
//  Created by 🍑 on 10/11/2019.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK:- Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loadMap()
    }
    //MARK:-IBActions
    @IBAction func addLocation(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "add", sender: nil)
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        DispatchQueue.main.async {
            self.loadMap()
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
    func loadMap() {
        OTMClient.getStudentLocation { (studentsLocations, errorMsg, error) in
            if error == nil {
                DispatchQueue.main.async {
                    StudentsLocations.studentsLocations = studentsLocations
                    self.setAnnotations() //if no error occurs set up annotations on map
                }
            } else {
                self.showAlertMessage("Error", errorMsg!)
            }
        }
    }
    //MARK:- Setting up map
    func setAnnotations() {
        var annotations = [MKPointAnnotation]()
        for location in StudentsLocations.studentsLocations { //getting data from model
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            let coordination = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let firstName = location.firstName
            let lastName = location.lastName
            let mediaURL = location.mediaURL
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordination
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
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
    //MARK:- Opening URL
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}
    
    
    
    


//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by 🍑 on 29/10/2019.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    let createdAt: Date
    let updateAt: Date
}

struct GetStudentLocations: Codable {
    let results: [StudentLocation]
    
}

class StudentLocationsModel {
    static var studentLocationsModel = [StudentLocation]()
}

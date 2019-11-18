//
//  StudentLocation.swift
//  On The Map
//
//  Created by 🍑 on 08/11/2019.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
}

struct Results: Codable {
    let results: [StudentLocation]
}


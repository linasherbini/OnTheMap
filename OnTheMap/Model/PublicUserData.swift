//
//  PublicUserData.swift
//  OnTheMap
//
//  Created by 🍑 on 04/11/2019.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation

struct PublicUserData {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

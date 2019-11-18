//
//  PostSession.swift
//  On The Map
//
//  Created by 🍑 on 08/11/2019.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct PostSession: Codable {
    let account: Account
    let session: Session
    
}

struct DeleteSession {
    let session: Session
}

//
//  User.swift
//  Autolayout
//
//  Created by Sebastian Osiński on 20.07.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import Foundation

struct User {
    
    let name: String
    let company: String
    let login: String
    let password: String
    
    static func login(login: String, password: String) -> User? {
        if let user = database[login] {
            if user.password == password {
                return user
            }
        }
        return nil
    }
    
    static let database: [String : User] = {
        var theDatabase = [String : User]()
        
        for user in [
            User(name: "Sebastian Osiński", company: "Apple", login: "sebo", password: "foo"),
            User(name: "Malwina Jarosz", company: "PWr", login: "malwina", password: "bar")
            ] {
                theDatabase[user.login] = user
        }
    
        return theDatabase
    }()
}
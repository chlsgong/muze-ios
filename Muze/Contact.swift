//
//  Contact.swift
//  Muze
//
//  Created by Charles Gong on 8/9/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation

class Contact {
    var id: String
    var firstName: String
    var lastName: String
    var phoneNumber: String
    
    init(id: String, firstName: String, lastName: String, phoneNumber: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
    }
}

//
//  Contact.swift
//  Muze
//
//  Created by Charles Gong on 8/9/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation

class Contact {
    private(set) var id: String
    private(set) var firstName: String
    private(set) var lastName: String
    private(set) var phoneNumber: String
    
    init(id: String, firstName: String, lastName: String, phoneNumber: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
    }
}

//
//  Utility.swift
//  Muze
//
//  Created by Charles Gong on 7/25/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation
import Contacts

class Utility {
    private static let contactStore = CNContactStore()
    
    class func fetchContacts(completion: @escaping ([Contact], Error?) -> Void) {
        var contacts = [Contact]()
        var fetchRequestError: Error?
        
        let keys = [CNContactIdentifierKey as CNKeyDescriptor, CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
        fetchRequest.sortOrder = CNContactSortOrder.givenName
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try contactStore.enumerateContacts(with: fetchRequest) { cnContact, status in
                    for cnPhoneNumber in cnContact.phoneNumbers {
                        let phoneNumber = cnPhoneNumber.value.stringValue.normalizePhoneNumber()
                        let contact = Contact(id: cnContact.identifier, firstName: cnContact.givenName, lastName: cnContact.familyName, phoneNumber: phoneNumber)
                        contacts.append(contact)
                    }
                }
            }
            catch {
                contacts.removeAll()
                fetchRequestError = error
            }
            
            DispatchQueue.main.async {
                completion(contacts, fetchRequestError)
            }
        }
    }
}

extension String {
    func isNumeric() -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    func normalizePhoneNumber() -> String {
        let phoneNumber = String(self.characters.filter { "0123456789".characters.contains($0) })
        let index = phoneNumber.index(phoneNumber.startIndex, offsetBy: phoneNumber.characters.count - 10)
        return phoneNumber.substring(from: index)
    }
}

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
    
    func isExplicit() -> Bool {
        return self == ContentRating.explicit.rawValue
    }
    
    func normalizePhoneNumber() -> String {
        let phoneNumber = String(self.filter { "0123456789".contains($0) })
        let index = phoneNumber.index(phoneNumber.startIndex, offsetBy: phoneNumber.count - 10)
        return String(phoneNumber[index...])
    }
    
    func stringifyQuery(parameters: [String: String]) -> URL {
        var queryString = ""
        for (key, value) in parameters {
            queryString += "\(key)=\(value)&"
        }
        queryString.removeLast()
        
        var urlComponents = URLComponents(string: self)!
        urlComponents.query = queryString
        return urlComponents.url!
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

extension Array where Element == SpotifyScope {
    func stringify() -> String {
        var scopesString = ""
        for scope in self {
            scopesString += "\(scope.rawValue) "
        }
        scopesString.removeLast()
        
        return scopesString
    }
}

extension Array where Element == String {
    func stringify() -> String {
        var combinedString = ""
        for string in self {
            combinedString += "\(string) "
        }
        combinedString.removeLast()
        
        return combinedString
    }
}

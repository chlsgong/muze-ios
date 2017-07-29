//
//  Utility.swift
//  Muze
//
//  Created by Charles Gong on 7/25/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation

class Utility {
}

extension String {
    func isNumeric() -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    func setDefault() -> String {
        return self.isEmpty ? "None": self
    }
}

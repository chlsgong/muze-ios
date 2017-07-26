//
//  UIUtil.swift
//  Muze
//
//  Created by Charles Gong on 6/18/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import UIKit

class UIUtil {
}

extension UIViewController {
    func performSegue(withIdentifier id: Identifier.Segue, sender: Any?) {
        self.performSegue(withIdentifier: id.rawValue, sender: sender)
    }
}

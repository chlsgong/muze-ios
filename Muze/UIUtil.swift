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

extension UIStoryboardSegue {
    func isIdentified(byId id: Identifier.Segue) -> Bool {
        return self.identifier == id.rawValue
    }
}

extension UITableView {
    func dequeueReusableCell(withIdentifier id: Identifier.Cell, for indexPath: IndexPath) -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: id.rawValue, for: indexPath)
    }
}

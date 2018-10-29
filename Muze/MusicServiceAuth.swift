//
//  MusicServiceAuth.swift
//  Muze
//
//  Created by Charles Gong on 10/21/18.
//  Copyright © 2018 Charles Gong. All rights reserved.
//

import Foundation
import StoreKit

protocol MusicServiceAuth {
    func requestAuthorization(completion: @escaping () -> Void)
    func getSession(completion: @escaping (Error?) -> Void)
}

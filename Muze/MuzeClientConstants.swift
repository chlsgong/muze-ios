//
//  MuzeClientConstants.swift
//  Muze
//
//  Created by Charles Gong on 7/25/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation

// API endpoints
enum Endpoint {
    case postVerificationCode
    case getVerificationCheck
    case putUsersAPNToken
    
    var url: String {
        let host = "http://10.175.1.25:3000"
        
        switch self {
        case .postVerificationCode: return host + "/verification/code"
        case .getVerificationCheck: return host + "/verification/check"
        case .putUsersAPNToken: return host + "/users/apntoken"
        }
    }
}


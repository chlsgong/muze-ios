//
//  MuzeClient.swift
//  Muze
//
//  Created by Charles Gong on 7/25/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MuzeClient {
    
    func requestVerificationCode(phoneNumber: String, completion: @escaping (String?) -> Void) {
        let parameter = [
            "phone_number": phoneNumber
        ]
        
        request(endpoint: .postVerificationCode, method: .post, parameters: parameter).responseData { response in
            var error: String?
            
            var code = response.response!.statusCode
            if response.result.isFailure {
                
            }
            completion(error)
        }
    }
    
    // MARK: - Wrappers
    
    private func request(endpoint: Endpoint, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.queryString, header: HTTPHeaders? = nil) -> DataRequest {
        return MuzeClientSession.manager.request(endpoint.url, method: method, parameters: parameters, encoding: encoding, headers: header).validate()
    }
}

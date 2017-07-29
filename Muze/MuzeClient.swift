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
    
    // MARK: - HTTP methods
    
    func requestVerificationCode(phoneNumber: String, completion: @escaping (Error?) -> Void) {
        let parameter = [
            "phone_number": phoneNumber
        ]
        
        request(endpoint: .postVerificationCode, method: .post, parameters: parameter).responseData { response in
            let error = response.result.error
            self.handleHTTPError(error: error)
            completion(error)
        }
    }
    
    func checkVerificationCode(phoneNumber: String, code: String, apnToken: String, completion: @escaping (String?) -> Void) {
        let parameter = [
            "code": code,
            "phone_number": phoneNumber,
            "apn_token": apnToken.setDefault()
        ]
                
        request(endpoint: .getVerificationCheck, method: .get, parameters: parameter).responseJSON { response in
            var userId: String?
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                userId = json["user_id"].stringValue
                
            case .failure(let error):
                self.handleHTTPError(error: error)
            }
            completion(userId)
        }
    }
    
    func updateAPNToken(userId: String, apnToken: String, completion: ((Error?) -> Void)?) {
        let parameter = [
            "user_id": userId,
            "apn_token": apnToken
        ]
        
        request(endpoint: .putUsersAPNToken, method: .put, parameters: parameter, encoding: JSONEncoding.default).responseData { response in
            let error = response.result.error
            self.handleHTTPError(error: error)
            completion?(error)
        }
    }
    
    // MARK: - Wrappers
    
    private func request(endpoint: Endpoint, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.queryString, header: HTTPHeaders? = nil) -> DataRequest {
        return MuzeClientSession.manager.request(endpoint.url, method: method, parameters: parameters, encoding: encoding, headers: header).validate()
    }
    
    // MARK: - Helpers
    
    private func handleHTTPError(error: Error?) {
        if let error = error as? AFError {
            switch error {
            case .invalidURL(let url):
                print("Invalid URL: \(url) - \(error.localizedDescription)")
            case .parameterEncodingFailed(let reason):
                print("Parameter encoding failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
            case .multipartEncodingFailed(let reason):
                print("Multipart encoding failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
            case .responseValidationFailed(let reason):
                print("Response validation failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
                
                switch reason {
                case .dataFileNil, .dataFileReadFailed:
                    print("Downloaded file could not be read")
                case .missingContentType(let acceptableContentTypes):
                    print("Content Type Missing: \(acceptableContentTypes)")
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                case .unacceptableStatusCode(let code):
                    print("Response status code was unacceptable: \(code)")
                }
            case .responseSerializationFailed(let reason):
                print("Response serialization failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
            }
            
            print("Underlying error: \(error.underlyingError?.localizedDescription ?? "unknown")")
        } else if let error = error as? URLError {
            print("URLError occurred: \(error.localizedDescription)")
        } else {
            print("Unknown error: \(error?.localizedDescription ?? "unknown")")
        }
    }
}

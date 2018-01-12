//
//  MusicClient.swift
//  Muze
//
//  Created by Charles Gong on 9/12/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MusicClient {
    let token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkU5R01WQUQ1RFQifQ.eyJpYXQiOjE1MDQ1NjA1NTUsImV4cCI6MTUyMDExMjU1NSwiaXNzIjoiSE1ZQ05FNTlTMiJ9.tzdfkF4U5xsJTIG46y78JKGV76ZBkpYm44744koMQmnQsjBNspyR8DNr58b4zgWYaONk8kYeQ2xQffXzkrA5-g"
    
    func getSong() {
        let parameter = [
            "term": "HUMBLE.+Kendrick+Lamar",
            "types": "songs"
        ]
        
        let header = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request("https://api.music.apple.com/v1/catalog/us/search", method: .get, parameters: parameter, encoding: URLEncoding.queryString, headers: header).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let results = json["results"]
                let songs = results["songs"]
                let data = songs["data"].arrayValue
                print(data.count)
                
            case .failure(let error):
                print("error")
            }
        }
    }
}

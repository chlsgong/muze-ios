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
    let token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkU5R01WQUQ1RFQifQ.eyJpc3MiOiJITVlDTkU1OVMyIiwiaWF0IjoxNTMwNDY5ODU1LCJleHAiOjE1MzgzNTgzNTV9.HiQa2wL3Wu0dLkpZ0DxUX-Ek1abO2Hu3aTWz3-_8zDmjecRhVKgb5DZwFWueNALzne9WeGkI6OjdbLx0n9KxVg"
    
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
    
    // Spotify requests
    // TODO: Spotify logout call
    
    func authorizeSpotify(completion: @escaping () -> Void) {
        let parameters = [
            "client_id": spotifyClientId,
            "response_type": "code",
            "redirect_uri": redirectUri,
            "scope": "user-read-private" // TODO: add more scopes
        ]
        
        // TODO: Stringify function
        var queryString = "?"
        for (key, value) in parameters {
            queryString += (key + "=" + value)
            queryString += "&"
        }
        queryString.removeLast()
        
        let url = ServiceEndpoint.getAuthorizeSpotify.url + queryString
        
        UIApplication.shared.open(URL(string: url)!, options: [:]) { _ in
            completion()
        }
    }
    
    // Helpers
    
    private func request(endpoint: ServiceEndpoint, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.queryString, header: HTTPHeaders? = nil) -> DataRequest {
        return Alamofire.request(endpoint.url, method: method, parameters: parameters, encoding: encoding, headers: header).validate()
    }
}

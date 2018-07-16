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
                print("error", error)
            }
        }
    }
    
    // Spotify requests
    // TODO: Spotify logout call
    
    func authorizeSpotify(completion: @escaping () -> Void) {
        let parameters = [
            "client_id": SpotifyAuth.clientId,
            "response_type": SpotifyAuth.responseType,
            "redirect_uri": SpotifyAuth.redirectUri,
            "scope": SpotifyAuth.scopes
        ]
        let url = ServiceEndpoint.getAuthorizeSpotify.url.stringifyQuery(parameters: parameters)
        
        UIApplication.shared.open(url, options: [:]) { _ in
            completion()
        }
    }
    
    func requestSpotifyTokens(completion: @escaping (String?, Int?, String?, Error?) -> Void ) {
        let encodedClientKeys = "\(SpotifyAuth.clientId):\(SpotifyAuth.clientSecret)".toBase64()
        let header = ["Authorization": "Basic \(encodedClientKeys)"]
        let parameters = [
            "grant_type": SpotifyAuth.grantType,
            "code": SpotifyAuth.code!,
            "redirect_uri": SpotifyAuth.redirectUri
        ]
        
        request(endpoint: .postToken, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: header).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let accessToken = json["access_token"].stringValue
                let expiresIn = json["expires_in"].intValue
                let refreshToken = json["refresh_token"].stringValue
                print("accessToken", accessToken)
                print("expiresIn", expiresIn)
                print("refreshToken", refreshToken)
                completion(accessToken, expiresIn, refreshToken, nil)
            case .failure(let error):
                print("error", error)
                completion(nil, nil, nil, error)
            }
        }
    }
    
    // Helpers
    
    private func request(endpoint: ServiceEndpoint, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.queryString, headers: HTTPHeaders? = nil) -> DataRequest {
        return Alamofire.request(endpoint.url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate()
    }
}

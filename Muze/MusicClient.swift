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
    
    func requestSpotifyTokens(completion: @escaping (String?, Int?, String?, Error?) -> Void) {
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
                
                DispatchQueue.main.async {
                    completion(accessToken, expiresIn, refreshToken, nil)
                }
            case .failure(let error):
                print("error", error)
                DispatchQueue.main.async {
                    completion(nil, nil, nil, error)
                }
            }
        }
    }
    
    func requestSpotifyAccessToken(refreshToken: String, completion: @escaping (String?, Int?, Error?) -> Void) {
        let encodedClientKeys = "\(SpotifyAuth.clientId):\(SpotifyAuth.clientSecret)".toBase64()
        let header = ["Authorization": "Basic \(encodedClientKeys)"]
        let parameters = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        ]
        
        request(endpoint: .postToken, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: header).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let accessToken = json["access_token"].stringValue
                let expiresIn = json["expires_in"].intValue
                print("accessToken", accessToken)
                print("expiresIn", expiresIn)
                
                DispatchQueue.main.async {
                    completion(accessToken, expiresIn, nil)
                }
            case .failure(let error):
                print("error", error)
                DispatchQueue.main.async {
                    completion(nil, nil, error)
                }
            }
        }
    }
    
    func getCurrentUser(completion: @escaping (String?, Error?) -> Void) {
        let header = ["Authorization": "Bearer \(SpotifyAuth.accessToken!)"]
        
        request(endpoint: .getCurrentUser, method: .get, headers: header).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let userId = json["id"].stringValue
                
                DispatchQueue.main.async {
                    completion(userId, nil)
                }
            case .failure(let error):
                print("error", error)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    func createPlaylist(title: String, completion: @escaping (String?, Error?) -> Void) {
        let header = ["Authorization": "Bearer \(SpotifyAuth.accessToken!)"]
        let parameter = [
            "name": title
        ]
        
        request(endpoint: .postCreatePlaylist, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let value):
                let playlist = JSON(value)
                let id = playlist["id"].stringValue
                
                DispatchQueue.main.async {
                    completion(id, nil)
                }
            case .failure(let error):
                print("error", error)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    func querySong(title: String, artist: String, type: String = "track", completion: @escaping (String?, String?, Error?) -> Void) {
        let header = ["Authorization": "Bearer \(SpotifyAuth.accessToken!)"]
        let parameters = [
            "q": "\(title) \(artist)",
            "type": type
        ]
        
        request(endpoint: .getSearch, method: .get, parameters: parameters, headers: header).responseJSON { response in
            switch response.result {
            case .success(let value):
                let response = JSON(value)["tracks"].dictionaryValue
                let items = response["items"]!.arrayValue
                let track = items[0]
                let id = track["id"].stringValue
                let name = track["name"].stringValue
                let isExplicit = track["explicit"].boolValue
                
                DispatchQueue.main.async {
                    completion(id, name, nil)
                }
            case .failure(let error):
                print("error", error)
                DispatchQueue.main.async {
                    completion(nil, nil, error)
                }
            }
        }
    }
    
    func addTracksToPlaylist(playlistId: String, trackIds: [String], completion: @escaping (Error?) -> Void) {
        let header = ["Authorization": "Bearer \(SpotifyAuth.accessToken!)"]
        let parameters = [
            "uris": spotifyUriList(forTrackIds: trackIds)
        ]
        
        request(endpoint: .postAddTracksToPlaylist(playlistId), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(_):
                DispatchQueue.main.async {
                    completion(nil)
                }
            case .failure(let error):
                print("error", error)
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    // Helpers
    
    private func request(endpoint: ServiceEndpoint, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.queryString, headers: HTTPHeaders? = nil) -> DataRequest {
        return Alamofire.request(endpoint.url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate()
    }
    
    private func spotifyUriList(forTrackIds trackIds: [String]) -> [String] {
        return trackIds.map { return "spotify:track:\($0)" }
    }
}

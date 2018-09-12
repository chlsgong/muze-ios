//
//  AppleMusicClient.swift
//  Muze
//
//  Created by Charles Gong on 9/6/18.
//  Copyright © 2018 Charles Gong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AppleMusicClient {
    static let shared = AppleMusicClient()
    
    private var devToken = User.standard.appleMusicDevToken
    private var userToken = User.standard.appleMusicUserToken
    
    private init() {}
    
    func getSong() {
        let parameter = [
            "term": "HUMBLE.+Kendrick+Lamar",
            "types": "songs"
        ]
        
        let header = [
            "Authorization": "Bearer \(devToken)"
        ]
        
        Alamofire.request("https://api.music.apple.com/v1/catalog/us/search", method: .get, parameters: parameter, encoding: URLEncoding.queryString, headers: header).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let results = json["results"]
                let songs = results["songs"]
                let data = songs["data"].arrayValue
                print(data.count)
                print(data)
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    func getPlaylists(completion: @escaping ([String]?, Error?) -> Void) {
        let headers = [
            "Authorization": "Bearer \(devToken)",
            "Music-User-Token": userToken
        ]
        
        request(endpoint: .getLibraryPlaylists, method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let data = json["data"].arrayValue
                
                var playlistTitles = [String]()
                for playlist in data {
                    let attributes = playlist["attributes"].dictionaryValue
                    let title = attributes["name"]!.stringValue
                    playlistTitles.append(title)
                }
                
                DispatchQueue.main.async {
                    completion(playlistTitles, nil)
                }
            case .failure(let error):
                print("error", error)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    // MARK: Helpers
    
    private func request(endpoint: AppleMusicEndpoint, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.queryString, headers: HTTPHeaders? = nil) -> DataRequest {
        return Alamofire.request(endpoint.url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate()
    }
}

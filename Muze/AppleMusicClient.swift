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

class AppleMusicClient: MusicServiceClient {
    static let shared = AppleMusicClient()
    
    private init() {}
    
    private let user = User.standard
    
    private var devToken: String { return user.appleMusicDevToken }
    private var userToken: String { return user.appleMusicUserToken }
    
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
    
    // MARK: HTTP methods
    
    func getPlaylists(completion: @escaping ([PlaylistModel]?, Error?) -> Void) {
        let headers = [
            "Authorization": "Bearer \(devToken)",
            "Music-User-Token": userToken
        ]
        
        request(endpoint: .getLibraryPlaylists, method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let data = json["data"].arrayValue
                
                var playlists = [PlaylistModel]()
                for playlistData in data {
                    let id = playlistData["id"].stringValue
                    let attributes = playlistData["attributes"]
                    let title = attributes["name"].stringValue
                    
                    let playlist = PlaylistModel(appleMusicId: id, title: title)
                    playlists.append(playlist)
                }
                
                DispatchQueue.main.async {
                    completion(playlists, nil)
                }
            case .failure(let error):
                print("error", error)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    func getPlaylistTracks(playlist: PlaylistModel, completion: @escaping (PlaylistModel, Error?) -> Void) {
        let headers = [
            "Authorization": "Bearer \(devToken)",
            "Music-User-Token": userToken
        ]
        
        request(endpoint: .getLibraryPlaylistTracks(playlist.appleMusicId), method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let data = json["data"].arrayValue
                
                var tracks = [Track]()
                for trackData in data {
                    let id = trackData["id"].stringValue
                    let attributes = trackData["attributes"]
                    let title = attributes["name"].stringValue
                    let artist = attributes["artistName"].stringValue
                    let isExplicit = attributes["contentRating"].stringValue.isExplicit()
                    
                    let track = Track(appleMusicId: id, title: title, artist: artist, isExplicit: isExplicit)
                    tracks.append(track)
                }
                playlist.update(tracks: tracks, size: tracks.count)
                
                DispatchQueue.main.async {
                    completion(playlist, nil)
                }
            case .failure(let error):
                print("error", error)
                DispatchQueue.main.async {
                    completion(playlist, error)
                }
            }
            
        }
    }
    
    func createPlaylist(playlist: PlaylistModel, completion: @escaping (Error?) -> Void) {
        let headers = [
            "Authorization": "Bearer \(devToken)",
            "Music-User-Token": userToken
        ]
        
        let parameters = [
            "attributes": ["name": playlist.title],
            "relationships": ["tracks": playlist.appleMusicTracksRequestData()]
        ]
        
        request(endpoint: .postCreateLibraryPlaylist, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let data = json["data"].arrayValue
                let id = data[0]["id"].stringValue
                print(id)
                
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
    
    func addTracksToPlaylist(playlist: PlaylistModel, completion: @escaping (Error?) -> Void) {
        let headers = [
            "Authorization": "Bearer \(devToken)",
            "Music-User-Token": userToken
        ]
        
        let parameters = playlist.appleMusicTracksRequestData()
        
        request(endpoint: .postAddLibraryPlaylistTracks(playlist.appleMusicId), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
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
    
    func queryTrack() {
    }
    
    // MARK: Helpers
    
    private func request(endpoint: AppleMusicEndpoint, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.queryString, headers: HTTPHeaders? = nil) -> DataRequest {
        return Alamofire.request(endpoint.url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate()
    }
}

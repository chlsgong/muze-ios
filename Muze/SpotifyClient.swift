//
//  SpotifyClient.swift
//  Muze
//
//  Created by Charles Gong on 9/13/18.
//  Copyright © 2018 Charles Gong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SpotifyClient: MusicServiceClient {
    static let shared = SpotifyClient()
    
    private init() {}
    
    private let user = User.standard
    private let spotifyAuth = SpotifyAuth.shared
    
    private var accessToken: String { return spotifyAuth.accessToken! }
    
    func getPlaylists(completion: @escaping ([PlaylistModel]?, Error?) -> Void) {
        spotifyAuth.getHeader { header in
            self.request(endpoint: .getPlaylists, method: .get, headers: header).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let data = json["items"].arrayValue
                    
                    var playlists = [PlaylistModel]()
                    for playlistData in data {
                        let id = playlistData["id"].stringValue
                        let title = playlistData["name"].stringValue
                        
                        let playlist = PlaylistModel(spotifyId: id, title: title)
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
    }
    
    func getPlaylistTracks(playlist: PlaylistModel, completion: @escaping (PlaylistModel, Error?) -> Void) {
        spotifyAuth.getHeader { header in
            self.request(endpoint: .getPlaylistTracks(playlist.spotifyId), method: .get, headers: header).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let data = json["items"].arrayValue
                    
                    var tracks = [Track]()
                    for trackData in data {
                        let id = trackData["id"].stringValue
                        let title = trackData["name"].stringValue
                        let artist = trackData["artistName"].stringValue
                        let contentRating = trackData["contentRating"].stringValue
                        
                        let track = Track(spotifyId: id, title: title, artist: artist, contentRating: contentRating)
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
    }

    func createPlaylist(playlist: PlaylistModel, completion: @escaping (Error?) -> Void) {
        spotifyAuth.getHeader { header in
            let parameter = [
                "name": playlist.title
            ]
            
            self.request(endpoint: .postCreatePlaylist(self.user.spotifyUserId), method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let playlist = JSON(value)
                    let id = playlist["id"].stringValue
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
    }
    
    func addTracksToPlaylist(playlist: PlaylistModel, completion: @escaping (Error?) -> Void) {
        spotifyAuth.getHeader { header in
            let parameters = [
                "uris": self.spotifyUriList(forTracks: playlist.tracks)
            ]
            
            self.request(endpoint: .postAddTracksToPlaylist(playlist.spotifyId), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
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
    }
    
    func queryTrack() {
    }
    
    // MARK: Helpers
    
    private func request(endpoint: SpotifyEndpoint, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.queryString, headers: HTTPHeaders? = nil) -> DataRequest {
        return Alamofire.request(endpoint.url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate()
    }
    
    private func spotifyUriList(forTracks tracks: [Track]) -> [String] {
        return tracks.map { return "spotify:track:\($0.id)" }
    }
}

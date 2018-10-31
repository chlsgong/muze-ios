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
    
    func helloWorld() {
        MuzeClientSession.manager.request(ipAddress, method: .get).responseData { response in
            switch response.result {
            case .success(let value):
                print(JSON(value))
            case .failure(let error):
                self.handleHTTPError(error: error)
            }
        }
    }
    
    // MARK: - HTTP methods
    
    func requestVerificationCode(phoneNumber: String, completion: ((Error?) -> Void)?) {
        let parameter = [
            "phone_number": phoneNumber
        ]
        
        request(endpoint: .postVerificationCode, method: .post, parameters: parameter).responseData { response in
            let error = response.result.error
            self.handleHTTPError(error: error)
            
            DispatchQueue.main.async {
                completion?(error)
            }
        }
    }
    
    func checkVerificationCode(phoneNumber: String, code: String, apnToken: String, completion: @escaping (String?) -> Void) {
        let parameter = [
            "code": code,
            "phone_number": phoneNumber,
            "apn_token": apnToken
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
            
            DispatchQueue.main.async {
                completion(userId)
            }
        }
    }
    
    func getUser(userId: String, completion: @escaping (UserModel?) -> Void) {
        let parameter = [
            "user_id": userId
        ]
        
        request(endpoint: .getUsers, method: .get, parameters: parameter).responseJSON { response in
            var userModel: UserModel?
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let userId = json["id"].stringValue
                let phoneNumber = json["phoneNumber"].stringValue
                let badgeCount = json["badgeCount"].intValue
                let apnToken = json["apnToken"].stringValue
                let ownedPlaylists = json["ownedPlaylists"].arrayObject as! [String]
                let sharedPlaylists = json["sharedPlaylists"].arrayObject as! [String]
                userModel = UserModel(id: userId, phoneNumber: phoneNumber, badgeCount: badgeCount, apnToken: apnToken, ownedPlaylists: ownedPlaylists, sharedPlaylists: sharedPlaylists)
                
            case .failure(let error):
                self.handleHTTPError(error: error)
            }
            
            DispatchQueue.main.async {
                completion(userModel)
            }
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
            
            DispatchQueue.main.async {
                completion?(error)
            }
        }
    }
    
    func createPlaylist(creatorId: String, title: String, completion: ((Error?) -> Void)?) {
        let parameter = [
            "creator_id": creatorId,
            "title": title
        ]
        
        request(endpoint: .postPlaylist, method: .post, parameters: parameter, encoding: JSONEncoding.default).responseData { response in
            let error = response.result.error
            self.handleHTTPError(error: error)
            
            DispatchQueue.main.async {
                completion?(error)
            }
        }
    }
    
    func getPlaylistTitles(playlistIds: [String], completion: @escaping ([PlaylistModel]) -> Void) {
        var playlistTitles = [PlaylistModel]()
        let group = DispatchGroup()
        
        for id in playlistIds {
            group.enter()
            getPlaylistTitle(playlistId: id) { playlistModel in
                if playlistModel != nil {
                    playlistTitles.append(playlistModel!)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(playlistTitles)
        }
    }
    
    private func getPlaylistTitle(playlistId: String, completion: @escaping (PlaylistModel?) -> Void) {
        let parameter = [
            "playlist_id": playlistId
        ]
        
        request(endpoint: .getPlaylistTitle, method: .get, parameters: parameter).responseJSON { response in
            var playlistModel: PlaylistModel?
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let playlistId = json["id"].stringValue
                let title = json["title"].stringValue
                let creationTime = json["creationTime"].stringValue
                playlistModel = PlaylistModel(id: playlistId, title: title, creationTime: creationTime)
                
            case .failure(let error):
                self.handleHTTPError(error: error)
            }
            
            DispatchQueue.main.async {
                completion(playlistModel)
            }
        }
    }
    
    func getPlaylist(playlistModel: PlaylistModel, completion: @escaping (PlaylistModel) -> Void) {
        let parameter = [
            "playlist_id": playlistModel.id
        ]
        
        request(endpoint: .getPlaylist, method: .get, parameters: parameter).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let creatorId = json["creatorId"].stringValue
                let playlist = json["playlist"].arrayValue
                // TODO: change into utility function
                var tracks = [Track]()
                for trackData in playlist {
                    let appleMusicId = trackData["appleMusicId"].stringValue
                    let spotifyId = trackData["spotifyId"].stringValue
                    let title = trackData["title"].stringValue
                    let artist = trackData["artist"].stringValue
                    let isExplicit = trackData["isExplicit"].boolValue
                    let track = Track(appleMusicId: appleMusicId, spotifyId: spotifyId, title: title, artist: artist, isExplicit: isExplicit)
                    tracks.append(track)
                }
                let size = json["size"].intValue
                let creationTime = json["creationTime"].stringValue
                playlistModel.update(title: playlistModel.title, creationTime: creationTime, creatorId: creatorId, tracks: tracks, size: size)
                
            case .failure(let error):
                self.handleHTTPError(error: error)
            }
            
            DispatchQueue.main.async {
                completion(playlistModel)
            }
        }
    }
    
    func updatePlaylistSongs(playlistId: String, playlist: [MuzeTrackRequestData], size: Int, completion: ((Error?) -> Void)?) {
        let parameter: [String: Any] = [
            "playlist_id": playlistId,
            "playlist": playlist,
            "size": size
        ]
        
        request(endpoint: .putPlaylistSongs, method: .put, parameters: parameter, encoding: JSONEncoding.default).responseData { response in
            let error = response.result.error
            self.handleHTTPError(error: error)
            
            DispatchQueue.main.async {
                completion?(error)
            }
        }
        
    }
    
    func getPlaylistUsers(playlistId: String, completion: @escaping ([(String, String)]) -> Void) {
        let parameter = [
            "playlist_id": playlistId
        ]
        
        request(endpoint: .getPlaylistUsers, method: .get, parameters: parameter).responseJSON { response in
            var playlistUsers = [(String, String)]()
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let users = json["users"].arrayValue
                for user in users {
                    let userId = user["id"].stringValue
                    let phoneNumber = user["phoneNumber"].stringValue
                    playlistUsers.append((userId, phoneNumber))
                }
                    
            case .failure(let error):
                self.handleHTTPError(error: error)
            }
            
            DispatchQueue.main.async {
                completion(playlistUsers)
            }
        }
    }
    
    func addPlaylistUsers(playlistId: String, phoneNumbers: [String], completion: ((Error?) -> Void)?) {
        let parameter: [String: Any] = [
            "playlist_id": playlistId,
            "phone_numbers": phoneNumbers
        ]
        
        request(endpoint: .putPlaylistUsers, method: .put, parameters: parameter, encoding: JSONEncoding.default).responseData { response in
            let error = response.result.error
            self.handleHTTPError(error: error)
            
            DispatchQueue.main.async {
                completion?(error)
            }
        }
    }
    
    func deletePlaylistUser(playlistId: String, userId: String, completion: ((Error?) -> Void)?) {
        let parameter = [
            "playlist_id": playlistId,
            "user_id": userId
        ]
        
        request(endpoint: .deletePlaylistUsers, method: .delete, parameters: parameter, encoding: JSONEncoding.default).responseData { response in
            let error = response.result.error
            self.handleHTTPError(error: error)
            
            DispatchQueue.main.async {
                completion?(error)
            }
        }
    }
    
    // MARK: - Wrappers
    
    private func request(endpoint: Endpoint, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.queryString, headers: HTTPHeaders? = nil) -> DataRequest {
        return MuzeClientSession.manager.request(endpoint.url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate()
    }
    
    // MARK: - Helpers
    
    private func handleHTTPError(error: Error?) {
        guard error != nil else {
            return
        }
        
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

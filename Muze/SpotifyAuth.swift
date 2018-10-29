//
//  SpotifyAuth.swift
//  Muze
//
//  Created by Charles Gong on 10/14/18.
//  Copyright © 2018 Charles Gong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SpotifyAuth: MusicServiceAuth {
    static let shared = SpotifyAuth()
    
    private init() {}
    
    private let user = User.standard
    
    // MARK: Request constants
    
    private let _scopes: [SpotifyScope] = [
        .playlistModifyPrivate,
        .playlistModifyPublic,
        .playlistReadPrivate,
        .playlistReadCollaborative,
        .userLibraryModify,
        .userLibraryRead
    ]
    
    let responseType = "code"
    
    private let clientId = "0c57961c512a4ab1bde7c3d6fcc045e7"
    private let clientSecret = "9763ecb79f7b4e8f8cef5850ccd2172f"
    private let redirectUri = "muze://"
    private let grantType = "authorization_code"
    private var scopes: String { return _scopes.stringify() }
    
    // MARK: Session data
    
    var code: String?

    private var expirationDate: Date?
    private var refreshToken: String { return user.spotifyRefreshToken }
    
    private(set) var accessToken: String?
    
    // MARK: MusicServiceAuth protocol methods
    
    func requestAuthorization(completion: @escaping () -> Void) {
        authorizeSpotify(completion: completion)
    }
    
    func getSession(completion: @escaping (Error?) -> Void) {
        requestSpotifyTokens { error in
            if error == nil {
                self.getCurrentUser { error in
                    completion(error)
                }
            }
            else {
                completion(error)
            }
        }
    }
    
    // MARK: Authorization methods
    // TODO: Spotify logout call
    // TODO: Put header in helper function
    
    func authorizeSpotify(completion: @escaping () -> Void) {
        let parameters = [
            "client_id": clientId,
            "response_type": responseType,
            "redirect_uri": redirectUri,
            "scope": scopes
        ]
        let url = SpotifyEndpoint.getAuthorizeSpotify.url.stringifyQuery(parameters: parameters)
        
        UIApplication.shared.open(url, options: [:]) { _ in
            completion()
        }
    }
    
    func requestSpotifyTokens(completion: @escaping (Error?) -> Void) {
        let encodedClientKeys = "\(clientId):\(clientSecret)".toBase64()
        let header = [
            "Authorization": "Basic \(encodedClientKeys)"
        ]
        let parameters = [
            "grant_type": grantType,
            "code": code!,
            "redirect_uri": redirectUri
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
                
                self.user.spotifyRefreshToken = refreshToken
                self.accessToken = accessToken
                self.expirationDate = self.accessTokenExpirationDate(expiringIn: expiresIn)
                
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
    
    func requestSpotifyAccessToken(completion: @escaping (Error?) -> Void) {
        let encodedClientKeys = "\(clientId):\(clientSecret)".toBase64()
        let header = [
            "Authorization": "Basic \(encodedClientKeys)"
        ]
        let parameters = [
            "grant_type": "refresh_token",
            "refresh_token": user.spotifyRefreshToken
        ]
        
        request(endpoint: .postToken, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: header).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let accessToken = json["access_token"].stringValue
                let expiresIn = json["expires_in"].intValue
                print("accessToken", accessToken)
                print("expiresIn", expiresIn)
                
                self.accessToken = accessToken
                self.expirationDate = self.accessTokenExpirationDate(expiringIn: expiresIn)
                
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
    
    func getCurrentUser(completion: @escaping (Error?) -> Void) {
        getHeader { header in
            self.request(endpoint: .getCurrentUser, method: .get, headers: header).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let userId = json["id"].stringValue
                    
                    self.user.spotifyUserId = userId
                    
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
    
    func getHeader(completion: @escaping ([String: String]) -> Void) {
        refreshAccessTokenIfNeeded { error in
            if error == nil {
                let header = ["Authorization": "Bearer \(self.accessToken!)"]
                completion(header)
            }
            else {
                print(error!)
            }
        }
    }
    
    // MARK: Helpers
    
    private func request(endpoint: SpotifyEndpoint, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.queryString, headers: HTTPHeaders? = nil) -> DataRequest {
        return Alamofire.request(endpoint.url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate()
    }
    
    private func accessTokenExpirationDate(expiringIn interval: Int) -> Date {
        return Date(timeIntervalSinceNow: Double(interval - 1000))
    }
    
    private func refreshAccessTokenIfNeeded(completion: @escaping (Error?) -> Void) {
        if Date() > expirationDate! {
            requestSpotifyAccessToken { error in
                completion(error)
            }
        }
        else {
            completion(nil)
        }
    }
}

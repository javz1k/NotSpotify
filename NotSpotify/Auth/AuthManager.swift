//
//  AuthManager.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 25.04.24.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    struct Constants {
        static let clientId = "f0641c0e78b8488e8e848aa181e40733"
        static let clientSecret = "7959151f315b465e8f86a4aa7e4a8eb2"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    }
    
    var signInURL: URL? {
        let scopes = "user-read-private"
        let redirectURI = "https://www.google.com"
        let client_id = Constants.clientId;
        let urlString = "https://accounts.spotify.com/authorize?response_type=code&client_id=\(client_id)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        
        return URL(string: urlString)
    }
    
    var isSignedIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool? {
        return false
    }
    
    func exchangeCodeForToken(code:String,completion:@escaping((Bool) -> Void)){
        //get token
        guard let url = URL(string: Constants.tokenAPIURL) else {return}
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        
       let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return}
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
               print("SUCCESS: \(json)")
           }catch{
               completion(false)
               print(error.localizedDescription)
           }
        }
        task.resume()

    }
    
    func cacheToken(){
        
    }
    
    func refreshAccessToken(){
        
    }
}

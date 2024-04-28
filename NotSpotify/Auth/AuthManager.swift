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
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool? {
        guard let expirationDate = tokenExpirationDate else {return false}
        let currentDate  = Date()
        let fiveMin:TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMin) >= expirationDate
    }
    
    func exchangeCodeForToken(code:String,completion:@escaping((Bool) -> Void)){
        //get token
        guard let url = URL(string: Constants.tokenAPIURL) else {return}
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: "https://www.google.com")
        ]
        let basicToken = Constants.clientId + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completion(false)
            return
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
       let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                print("fail to base 64")
                return}
           do {
               let result = try JSONDecoder().decode(AuthResponseModel.self, from: data)
               completion(true)
               self?.cacheToken(result:result)
               print("SUCCESS: \(result)")
           }catch{
               completion(false)
               print(error.localizedDescription)
           }
        }
        task.resume()

    }
    
    func cacheToken(result: AuthResponseModel){
        UserDefaultsHelper.defaults.setValue(result.access_token, forKey: "access_token")
        
        if let refresh_token = result.refresh_token {
            UserDefaultsHelper.defaults.setValue(refresh_token, forKey: "refresh_token")
        }

        
        if let expirationDate = Calendar.current.date(byAdding: .second, value: result.expires_in ?? 3600, to: Date()) {
            UserDefaultsHelper.defaults.setValue(expirationDate, forKey: "expirationDate")
        } else {
            print("Failed to calculate expiration date.")
        }

    }
    
    func refreshAccessTokenIfNeed(completion:@escaping ((Bool) -> Void)){
        guard let shouldRefreshToken else {
            completion(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else {return}
        
        
        //Get token again after 3600 seconds
        guard let url = URL(string: Constants.tokenAPIURL) else {return}
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        let basicToken = Constants.clientId + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completion(false)
            return
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
       let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                print("fail to base 64")
                return}
           do {
               let result = try JSONDecoder().decode(AuthResponseModel.self, from: data)
               completion(true)
               self?.cacheToken(result:result)
               print("SUCCESS Updated refresh token: \(result)")
           }catch{
               completion(false)
               print(error.localizedDescription)
           }
        }
        task.resume()
        
        
    }
}

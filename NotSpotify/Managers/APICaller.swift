//
//  APICaller.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 29.04.24.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init(){}
    
    struct Constants {
        static let baseAPIUrl = "https://api.spotify.com/v1"
    }
    enum APIError: Error {
        case failedToGetData
    }
    
    public func getCurrentUserProfile(completion:@escaping((Result<UserProfileModel, Error>) -> Void)){
        createRequest(with: URL(string: Constants.baseAPIUrl + "/me"),
                      type: .Get
        ){ baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(result)
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    enum HTTPMethod: String {
        case Get
        case Post
    }
    
    private func createRequest(with url:URL?,
                               type:HTTPMethod,
                               completion:@escaping((URLRequest) -> Void)) {
        AuthManager.shared.withValidToken { token in
            guard let APIUrl = url else {
                return
            }
            
            var request = URLRequest(url: APIUrl)
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            request.setValue("Bearer \(token)",
                             forHTTPHeaderField: "Authorization")
            completion(request)
        }
    }
    
}

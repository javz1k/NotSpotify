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
    
    //Albums
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailResponseModel, Error>) -> Void){
        createRequest(
            with: URL(string: Constants.baseAPIUrl + "/albums/" + album.id),
            type: .Get
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(AlbumDetailResponseModel.self, from: data)
                    completion(.success(result))
                    print(result)
                }
                catch{
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    }
    
    //Playlist
    public func getPlaylistDetails(for playlist: PlaylistModel, completion: @escaping (Result<PlaylistDetailResponseModel, Error>) -> Void){
        createRequest(
            with: URL(string: Constants.baseAPIUrl + "/playlists/" + playlist.id),
            type: .Get
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(PlaylistDetailResponseModel.self, from: data)
                    completion(.success(result))
                }
                catch{
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
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
//                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(UserProfileModel.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print("API caller getCurrentUserProfile error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    public func getNewReleases(completion:@escaping((Result<NewReleasesResponseModel, Error>) -> Void)){
        createRequest(with: URL(string: Constants.baseAPIUrl + "/browse/new-releases?limit=50"), type: .Get) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(NewReleasesResponseModel.self, from: data)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getFeaturedPlaylists(completion:@escaping((Result<FeaturedPlaylistResponseModel, Error>) -> Void)){
        createRequest(with: URL(string: Constants.baseAPIUrl + "/browse/featured-playlists?limit=20"), type: .Get) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(FeaturedPlaylistResponseModel.self, from: data)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendations(genres: Set<String>, completion:@escaping((Result<Recomendations, Error>) -> Void)){
        let seeds = genres.joined(separator: ",")
        let url = URL(string: Constants.baseAPIUrl + "/recommendations?limit=20&seed_genres=\(seeds)")
        print("url: \(url!)")
        createRequest(
            with: url,
            type: .Get) { request in
                print("header: \(request.allHTTPHeaderFields ?? [:] )")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    let result = try JSONDecoder().decode(Recomendations.self, from: data)
                    completion(.success(result))
                    
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()

        }
    }
    
    
    public func getRecommendedGenre(completion:@escaping((Result<RecommendedGenreResponseModel, Error>) -> Void)){
        createRequest(with: URL(string: Constants.baseAPIUrl + "/recommendations/available-genre-seeds"), type: .Get) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
//                    let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    let result = try JSONDecoder().decode(RecommendedGenreResponseModel.self, from: data)
                    completion(.success(result))
                }
                catch{
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

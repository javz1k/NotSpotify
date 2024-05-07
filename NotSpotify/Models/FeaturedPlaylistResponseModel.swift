//
//  FeaturedPlaylistResponseModel.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 07.05.24.
//

import Foundation

struct FeaturedPlaylistResponseModel: Codable {
    let playlists : PlaylistResponse
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

struct Playlist: Codable {
    let description:String
    let external_urls: [String:String]
    let id: String
    let images: [APIImageModel]
    let name: String
    let owner:User
}

struct User: Codable {
    let display_name: String
    let external_urls:[String:String]
    let id: String
}


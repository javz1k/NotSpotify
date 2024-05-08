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
    let items: [PlaylistModel]
}


struct User: Codable {
    let display_name: String
    let external_urls:[String:String]
    let id: String
}


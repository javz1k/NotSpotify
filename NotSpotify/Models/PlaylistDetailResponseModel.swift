//
//  PlaylistDetailResponseModel.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 10.05.24.
//

import Foundation

struct PlaylistDetailResponseModel: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images : [APIImageModel]
    let name: String
    let tracks: PlaylistTrackResponse
}

struct PlaylistTrackResponse: Codable{
    let items: [PlaylistItems]
}

struct PlaylistItems: Codable{
    let track: AudioTrackModel
}

//
//  AlbumDetailResponseModel.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 10.05.24.
//

import Foundation


struct AlbumDetailResponseModel: Codable{
    let album_type: String
    let artists: [ArtistModel]
    let available_markets: [String]
    let external_urls : [String:String]
    let id: String
    let images: [APIImageModel]
    let label: String
    let name: String
    let tracks: TrackResponse
}

struct TrackResponse: Codable{
    let items: [AudioTrackModel]
}


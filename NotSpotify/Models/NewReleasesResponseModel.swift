//
//  NewReleasesResponseModel.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 07.05.24.
//

import Foundation

struct NewReleasesResponseModel: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse : Codable {
    let items : [Album]
}

struct Album : Codable {
    let album_type: String
    let available_markets: [String]
    let id: String
    let images: [APIImageModel]
    let name: String
    let release_date: String
    let total_tracks:Int
    let artists:[ArtistModel]
}




               
                

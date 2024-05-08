//
//  PlaylistModel.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 25.04.24.
//

import Foundation

struct PlaylistModel: Codable {
    let description:String
    let external_urls: [String:String]
    let id: String
    let images: [APIImageModel]
    let name: String
    let owner:User
}

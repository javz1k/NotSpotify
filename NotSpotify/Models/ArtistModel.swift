//
//  ArtistModel.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 25.04.24.
//

import Foundation

struct ArtistModel: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
}

//
//  RecomendationsResponseModel.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 08.05.24.
//

import Foundation

// MARK: - Recomendations

struct Recomendations: Codable {
    let seeds: [Seed]
    let tracks: [Track]
}

struct Seed: Codable {
    let afterFilteringSize: Int
    let afterRelinkingSize: Int
    let href: String?
    let id: String
    let initialPoolSize: Int
    let type: String
}

struct AlbumModel: Codable {
    let albumType: String
    let artists: [ArtistModel]
    let availableMarkets: [String]
    let externalUrls: [String: String]
    let href: String
    let id: String
    let images: [Image]
    let name: String
    let releaseDate: String
    let releaseDatePrecision: String
    let totalTracks: Int
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case type, uri
    }
}

struct ArtistModelR: Codable {
    let externalUrls: [String: String]
    let href: String
    let id: String
    let name: String
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, name, type, uri
    }
}

struct Image: Codable {
    let height: Int
    let url: String
    let width: Int
}

struct Track: Codable {
    let album: AlbumModel
    let artists: [ArtistModelR]
    let availableMarkets: [String]
    let discNumber: Int
    let durationMs: Int
    let explicit: Bool
    let externalIds: [String: String]
    let externalUrls: [String: String]
    let href: String
    let id: String
    let isLocal: Bool
    let name: String
    let popularity: Int
    let previewUrl: String?
    let trackNumber: Int
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case album, artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMs = "duration_ms"
        case explicit
        case externalIds = "external_ids"
        case externalUrls = "external_urls"
        case href, id
        case isLocal = "is_local"
        case name, popularity
        case previewUrl = "preview_url"
        case trackNumber = "track_number"
        case type, uri
    }
}

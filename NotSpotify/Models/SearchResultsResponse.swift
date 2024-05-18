//
//  SearchResultsResponse.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 18.05.24.
//

import Foundation

struct SearchResultsResponse: Codable {
    let albums:SearchAlbumResponse
    let playlists:SearchPlaylistsResponse
    let tracks:SearchTracksResponse
    let artists:SearchArtistsResponse
}

struct SearchAlbumResponse: Codable {
    let items: [Album]
}

struct SearchArtistsResponse: Codable {
    let items: [ArtistModel]
}

struct SearchTracksResponse: Codable {
    let items: [AudioTrackModel]
}

struct SearchPlaylistsResponse: Codable {
    let items: [PlaylistModel]
}

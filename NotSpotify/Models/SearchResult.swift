//
//  SearchResult.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 18.05.24.
//

import Foundation

enum SearchResult {
    case artist(model: ArtistModel)
    case album(model: Album)
    case track(model: AudioTrackModel)
    case playlist(model: PlaylistModel)
}


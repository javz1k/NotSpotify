//
//  PlaybackPresenter.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 26.05.24.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerDataSourse: AnyObject {
    var songName: String? { get }
    var subTitile: String? { get }
    var imageUrl: URL? { get }
}

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    
    private var track:AudioTrackModel?
    private var tracks = [AudioTrackModel]()
    private var trackTrack: Track?
    
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    
    
    var currentTrack: AudioTrackModel? {
        if let track = track, tracks.isEmpty {
            return track
        }
        else if let playerQueue = self.playerQueue, !tracks.isEmpty {
            let item = playerQueue.currentItem
            let items = playerQueue.items()
            guard let index = items.firstIndex(where: { $0 == item }) else {
                return nil
            }
            
            return tracks[index]
        }
        
        return nil
    }
    
    
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrackModel
    ){
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        player = AVPlayer(url: url)
        player?.volume = 0.5
        self.track = track
        self.tracks = []
        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        viewController.present(
            UINavigationController(rootViewController: vc), animated: true, completion: { [weak self] in
                self?.player?.play()
            })
    }
    
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrackModel]
    ){
        self.tracks = tracks
        self.track = nil
        
        let items: [AVPlayerItem] = tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? "") else { return nil }
            return  AVPlayerItem(url: url)
        })
        self.playerQueue?.volume = 0
        self.playerQueue?.play()
        self.playerQueue = AVQueuePlayer(items: items)
        let vc = PlayerViewController()
        vc.delegate = self
        vc.dataSource = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
     func startPlayback(
        from viewController: UIViewController,
        tracksTrack: Track
    ){
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
         viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    

}

extension PlaybackPresenter: PlayerViewControllerDelegate{
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
    
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        } else if let player = playerQueue {
            
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
            
        }
    }
    
    func didTapBack() {
        if tracks.isEmpty {
            player?.pause()
            player?.play()
        } else if let firstItem = playerQueue?.items().first {
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
            playerQueue?.volume = 0
        }

    }
    
    func didTapForward() {
        if tracks.isEmpty {
            player?.pause()
        }else if let player = playerQueue {
            playerQueue?.advanceToNextItem()
        }
    }
        
}


extension PlaybackPresenter: PlayerDataSourse {
    var songName: String? {
        return currentTrack?.name
    }
    
    var subTitile: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageUrl: URL? {
        print("Images imageURL: \(currentTrack?.album?.images.first)")
        return URL(string:currentTrack?.album?.images.first?.url ?? "")
    }
    
    
}

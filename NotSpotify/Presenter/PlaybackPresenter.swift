//
//  PlaybackPresenter.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 26.05.24.
//

import Foundation
import UIKit

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    
     func startPlayback(
        from viewController: UIViewController,
        track: AudioTrackModel
    ){
       let vc = PlayerViewController()
        vc.title = track.name
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        
    }
    
     func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrackModel]
    ){
        let vc = PlayerViewController()
         viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
     func startPlayback(
        from viewController: UIViewController,
        tracksTrack: Track
    ){
        let vc = PlayerViewController()
         viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    

}

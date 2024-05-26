//
//  PlayerViewController.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 25.04.24.
//

import UIKit

class PlayerViewController: UIViewController {
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGreen
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let controlsView = PlayerControlsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        configureBarButtons()
        controlsView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(
            x: 10,
            y: view.safeAreaInsets.top,
            width: view.frame.width - 20,
            height: view.frame.width
        )
        controlsView.frame = CGRect(
            x: 10,
            y: imageView.frame.maxY,
            width: view.frame.width-20,
            height: view.frame.height - imageView.frame.height
        )
    }
    private func configureBarButtons(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))

    }
    
    @objc private func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAction(){
        print("action")
    }
}


extension PlayerViewController: PlayerControlsViewDelegate {
    
    func PlayerControlsViewDidTapPlayPause(_ PlayerControlsView: PlayerControlsView) {
        print("sds")
    }
    
    func PlayerControlsViewDidTapBack(_ PlayerControlsView: PlayerControlsView) {
        print("sds")
    }
    
    func PlayerControlsViewDidTapForward(_ PlayerControlsView: PlayerControlsView) {
        print("sds")
    }
    
    
}

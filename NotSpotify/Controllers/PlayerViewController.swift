//
//  PlayerViewController.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 25.04.24.
// 20 dq

import UIKit
import SDWebImage

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapBack()
    func didTapForward()
    func didSlideSlider(_ value: Float)
}

class PlayerViewController: UIViewController {
    weak var dataSource:PlayerDataSourse?
    weak var delegate: PlayerViewControllerDelegate?
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGreen
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let controlsView = NotSpotify.PlayerControlsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        configureBarButtons()
        controlsView.delegate = self
        configure()
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
    
    private func configure () {
        imageView.sd_setImage(with: dataSource?.imageUrl, completed: nil)
        controlsView.configure(
            with: PlayerControlsViewDTO(
                title: dataSource?.songName,
                subTitile: dataSource?.subTitile
            ))
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
    func PlayerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
    
    func PlayerControlsViewDidTapPlayPause(_ PlayerControlsView: PlayerControlsView) {
        delegate?.didTapPlayPause()
    }
    
    func PlayerControlsViewDidTapBack(_ PlayerControlsView: PlayerControlsView) {
        delegate?.didTapBack()
    }
    
    func PlayerControlsViewDidTapForward(_ PlayerControlsView: PlayerControlsView) {
        delegate?.didTapForward()
    }
    
    
}

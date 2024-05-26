//
//  PlayerControlsView.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 26.05.24.
//

import Foundation
import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    func PlayerControlsViewDidTapPlayPause(_ PlayerControlsView: PlayerControlsView)
    func PlayerControlsViewDidTapBack(_ PlayerControlsView: PlayerControlsView)
    func PlayerControlsViewDidTapForward(_ PlayerControlsView: PlayerControlsView)
}

final class PlayerControlsView: UIView {
    
    weak var delegate:PlayerControlsViewDelegate?
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "This is my song"
        nameLabel.numberOfLines = 1
        nameLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        nameLabel.textColor = .secondaryLabel
        return nameLabel
    }()
    
    private let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Description of my song"
        subtitleLabel.numberOfLines = 1
        subtitleLabel.font = .systemFont(ofSize: 18, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        return subtitleLabel
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(
            UIImage(
                systemName: "backward.fill", withConfiguration:
                    UIImage.SymbolConfiguration(
                        pointSize: 28,
                        weight: .regular
                    )
            ),
            for: .normal)
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(
            UIImage(
                systemName: "forward.fill", withConfiguration:
                    UIImage.SymbolConfiguration(
                        pointSize: 28,
                        weight: .regular
                    )
            ),
            for: .normal)
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(
            UIImage(
                systemName: "pause", withConfiguration:
                    UIImage.SymbolConfiguration(
                        pointSize: 34,
                        weight: .regular
                    )
            ),
            for: .normal)
        return button
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(volumeSlider)
        addSubview(playPauseButton)
        addSubview(backButton)
        addSubview(forwardButton)
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 4, y: 4, width: frame.width, height: 50)
        subtitleLabel.frame = CGRect(x: 4, y: nameLabel.frame.maxY+10, width: frame.width, height: 50)
        
        volumeSlider.frame = CGRect(x: 10, y: subtitleLabel.frame.maxY + 60, width: frame.width - 20, height: 44)
        
        let buttonSize: CGFloat = 60
        
        playPauseButton.frame = CGRect(
            x: (frame.width - buttonSize) * 0.5,
            y: volumeSlider.frame.maxY + 10,
            width: buttonSize,
            height: buttonSize
        )
        
        backButton.frame = CGRect(x: playPauseButton.frame.minX - 120,
                                  y: playPauseButton.frame.minY,
                                  width: buttonSize,
                                  height: buttonSize
        )
        
        forwardButton.frame = CGRect(x: playPauseButton.frame.minX + 120,
                                  y: playPauseButton.frame.minY,
                                  width: buttonSize,
                                  height: buttonSize
        )
        
        
    }
    
    
    @objc private func didTapBack(){
        delegate?.PlayerControlsViewDidTapBack(self)
    }
    
    @objc private func didTapForward(){
        delegate?.PlayerControlsViewDidTapForward(self)
    }
    
    @objc private func didTapPlayPause(){
        delegate?.PlayerControlsViewDidTapPlayPause(self)
    }
}

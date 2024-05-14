//
//  PlaylistHeaderCollectionReusableView.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 10.05.24.
//

import UIKit
import SDWebImage

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    private lazy var nameLabel:UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    private lazy var descriptionLabel:UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    private lazy var ownerLabel:UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    private lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private lazy var playAllButton:UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(imageView)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action:#selector(didTapPlayAll), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize:CGFloat = frame.height/1.5
        imageView.frame = CGRect(x: (frame.width - imageSize)/2,
                                 y: 20,
                                 width: imageSize,
                                 height: imageSize)
        
        nameLabel.frame = CGRect(x: 10, y: imageView.frame.maxY + 4, width: frame.width - 20, height: 44)
        descriptionLabel.frame = CGRect(x: 10, y: nameLabel.frame.maxY + 2, width: frame.width - 20, height: 30)
        ownerLabel.frame = CGRect(x: 10, y: descriptionLabel.frame.maxY + 2, width: frame.width - 20, height: 30)
        playAllButton.frame = CGRect(x: frame.width - 100, y: frame.height - 65, width: 50, height: 50)
    }
    
    func configure(with viewModel: PlaylistHeaderViewModel){
        nameLabel.text = viewModel.playlistName
        descriptionLabel.text = viewModel.description
        ownerLabel.text = viewModel.ownerName
        imageView.sd_setImage(with: viewModel.artWorkUrl, completed: nil)
    }
    
    @objc private func didTapPlayAll(){
        delegate?.PlaylistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
}

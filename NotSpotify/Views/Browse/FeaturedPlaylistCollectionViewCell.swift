//
//  FeaturedPlaylistCollectionViewCell.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 09.05.24.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    
    
    
    private lazy var playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private lazy var playlistNameLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var creatorNameLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        creatorNameLabel.sizeToFit()
        let imageSize: CGFloat = contentView.bounds.height - 60
        
        //imageView
        playlistCoverImageView.frame = CGRect(x: (contentView.frame.width - imageSize)/2,
                                              y: 5,
                                              width: imageSize,
                                              height: imageSize)
        
        //nameLabel
        playlistNameLabel.frame = CGRect(x: 3,
                                         y: playlistCoverImageView.frame.maxY + 2,
                                         width: contentView.frame.width - 6,
                                         height: 28
        )
        //creatorLabel
        creatorNameLabel.frame = CGRect(x: 3,
                                        y: playlistNameLabel.frame.maxY + 2,
                                        width: contentView.frame.width - 6,
                                        height: 18
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
        playlistCoverImageView.image = nil
    }
    
    func configure(with ViewModel:FeaturedPlaylistCellViewModel){
        playlistNameLabel.text = ViewModel.name
        creatorNameLabel.text = ViewModel.creatorName
        playlistCoverImageView.sd_setImage(with: ViewModel.artWorkUrl, completed: nil)
    }
}

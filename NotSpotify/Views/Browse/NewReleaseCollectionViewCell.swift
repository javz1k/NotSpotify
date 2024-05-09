//
//  NewReleaseCollectionViewCell.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 09.05.24.
//

import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleaseCollectionViewCell"
    
    private lazy var albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var albumLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var numberOfTracksLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var nameOfArtistLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.addSubview(nameOfArtistLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.bounds.height - 10
        
        let albumLabelSize = albumLabel.sizeThatFits(
            CGSize(
                width: contentView.frame.width - imageSize - 10,
                height: contentView.frame.height - 10))
        
        nameOfArtistLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        
        
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        
        let albumNameHeight = min(60, albumLabelSize.height)
        albumLabel.frame = CGRect(x: albumCoverImageView.frame.maxX + 10,
                                  y: 5,
                                  width: albumLabelSize.width,
                                  height: albumNameHeight
        )
        
        
        nameOfArtistLabel.frame = CGRect(x: albumCoverImageView.frame.maxX + 10,
                                         y: albumLabel.frame.maxY,
                                         width: contentView.frame.width - albumCoverImageView.frame.maxX - 5,
                                         height: 30
        )
        
        
        numberOfTracksLabel.frame = CGRect(x: albumCoverImageView.frame.maxX + 10,
                                           y: contentView.frame.maxY - 44,
                                           width: numberOfTracksLabel.frame.width,
                                           height: 44
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumLabel.text = nil
        nameOfArtistLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with ViewModel:NewReleaseCellViewModel){
        albumLabel.text = ViewModel.name
        nameOfArtistLabel.text = ViewModel.artistName
        numberOfTracksLabel.text = "Track: \(ViewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: ViewModel.artWorkUrl, completed: nil)
    }
}

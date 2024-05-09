//
//  RecommendedTrackCollectionViewCell.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 09.05.24.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedTrackCollectionViewCell"
    
    
    private lazy var albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 2
        return imageView
    }()
    
    private lazy var trackNameLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var artistNameLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        artistNameLabel.sizeToFit()
        
        //albumCoverImageView
        albumCoverImageView.frame = CGRect(x: 5,
                                           y: 2,
                                           width: contentView.frame.height - 4,
                                           height: contentView.frame.height - 4)
        
        //trackNameLabel
        trackNameLabel.frame = CGRect(x: albumCoverImageView.frame.maxX + 10,
                                      y: 0,
                                      width: contentView.frame.width - albumCoverImageView.frame.maxX - 15,
                                      height: contentView.frame.height / 2
        )
        //artistNameLabel
        artistNameLabel.frame = CGRect(x: albumCoverImageView.frame.maxX + 10,
                                       y: contentView.frame.height / 2,
                                       width: contentView.frame.width - albumCoverImageView.frame.maxX - 15,
                                       height: contentView.frame.height / 2
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with ViewModel:RecommendedTrackCellViewModel){
        trackNameLabel.text = ViewModel.name
        artistNameLabel.text = ViewModel.artistName
        albumCoverImageView.sd_setImage(with: ViewModel.artWorkUrl, completed: nil)
    }
}

//
//  AlbumTrackCollectionViewCell.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 15.05.24.
//

import Foundation
import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumTrackCollectionViewCell"
    
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
    
        //trackNameLabel
        trackNameLabel.frame = CGRect(x: 10,
                                      y: 0,
                                      width: contentView.frame.width - 15,
                                      height: contentView.frame.height / 2
        )
        //artistNameLabel
        artistNameLabel.frame = CGRect(x: 10,
                                       y: contentView.frame.height / 2,
                                       width: contentView.frame.width - 15,
                                       height: contentView.frame.height / 2
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    func configure(with ViewModel:AlbumCollectionViewCellViewModel){
        trackNameLabel.text = ViewModel.name
        artistNameLabel.text = ViewModel.artistName
    }
}

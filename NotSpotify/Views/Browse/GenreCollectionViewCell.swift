//
//  GenreCollectionViewCell.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 15.05.24.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    static let identifier = "GenreCollectionViewCell"
    
    private lazy var imageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(
            pointSize: 40,
            weight: .regular) )
        return imageView
    }()
    
    private lazy var label: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(label)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 10,
                             y: contentView.frame.height/2,
                             width: contentView.frame.width-20,
                             height: contentView.frame.height/2
        )
        
        imageView.frame = CGRect(x: contentView.frame.width/2,
                                 y: 0,
                                 width: contentView.frame.width/2,
                                 height: contentView.frame.height/2
        )
        
    }
    
    func configure(with title: String){
        label.text = title
    }
}

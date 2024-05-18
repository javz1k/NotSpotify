//
//  SearchResultDefaultTableViewCell.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 19.05.24.
//

import UIKit
import SDWebImage

class SearchResultDefaultTableViewCell: UITableViewCell {
 static let identifier = "SearchResultDefaultTableViewCell"
    
    private lazy var label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(image)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        image.frame = CGRect(x: 10,
                             y: 5,
                             width: contentView.frame.height - 10,
                             height: contentView.frame.height - 10
        )
        image.layer.cornerRadius = (contentView.frame.height - 10) / 2
        image.layer.masksToBounds = true
        
        label.frame = CGRect(x: image.frame.maxX + 10,
                             y: 0,
                             width: contentView.frame.width - image.frame.maxX - 15,
                             height: contentView.frame.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
        label.text = nil
    }
    
    func configure(with model:SearchResultDefaultTableViewCellViewModel){
        label.text = model.title
        image.sd_setImage(with: model.imageURL, completed: nil)
    }

}

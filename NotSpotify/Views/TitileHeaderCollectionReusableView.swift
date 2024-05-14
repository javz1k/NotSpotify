//
//  TitileHeaderCollectionReusableView.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 14.05.24.
//

import UIKit

class TitileHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "TitileHeaderCollectionReusableView"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .light)
        return label
    }()
    
    
    override init(frame:CGRect){
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
        
    }
    
    required init(coder:NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 15, y: 0, width: frame.width - 30, height: frame.height)
    }
    
    func configure(title:String){
        label.text = title
    }
}

//
//  PostDatetimeCollectionViewCell.swift
//  Instagram-Clone
//
//  Created by Pedro Gomes Rubbo Pacheco on 20/04/21.
//

import UIKit

class PostDatetimeCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostDatetimeCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel: PostDatetimeCollectionViewCellViewModel) {
        
    }
}

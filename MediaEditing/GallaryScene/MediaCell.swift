//
//  MediaCell.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 10.10.2022.
//

import UIKit


class MediaCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

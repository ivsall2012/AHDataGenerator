//
//  AHPicCollectionCell.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/29/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit

let collectionCell = "collectionCell"

class AHPicCollectionCell: UICollectionViewCell {
    @IBOutlet weak var pictureView: UIImageView!
    
    var image: UIImage? {
        didSet{
            if let image = image {
                pictureView.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        pictureView.image = #imageLiteral(resourceName: "placeholder")
    }
}

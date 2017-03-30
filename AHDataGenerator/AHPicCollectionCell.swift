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
    var imageStr: String? {
        didSet{
            if let imageStr = imageStr {
                pictureView.image = UIImage(named: imageStr)
            }else{
                print("**** BUG ****")
            }
        }
    }
    
    override func prepareForReuse() {
        pictureView.image = nil
    }
}

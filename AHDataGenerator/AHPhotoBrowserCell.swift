//
//  AHPhotoBrowserCell.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/30/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit

let photoBrowserCellMargin: CGFloat = 5.0
class AHPhotoBrowserCell: UICollectionViewCell {
    @IBOutlet weak var scrollView: UIScrollView!
    private var imageView = UIImageView()
    
    var imageStr: String? {
        didSet{
            if let imageStr = imageStr {
                imageView.AH_setImage(urlStr: imageStr, completion: { (image) in
                    if let image = image {
                        self.calculateImageView(image: image)
                    }
                })
                
            }
        }
    }

    
    override func awakeFromNib() {
        scrollView.addSubview(imageView)
    }
    
    func calculateImageView(image: UIImage) {
        let superSize = UIScreen.main.bounds.size
        let imgSize = image.size
        let newWidth = superSize.width - 2*photoBrowserCellMargin
        let newHeight = newWidth * imgSize.height / imgSize.width
        let newX : CGFloat = photoBrowserCellMargin
        var newY: CGFloat
        if newHeight > superSize.height {
            // log photo
            newY = 0.0
        }else{
            // photo can fit in the screen
            newY = (superSize.height - newHeight) * 0.5
        }
        let newFrame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        imageView.frame = newFrame
        scrollView.contentSize = CGSize(width: superSize.width, height: newHeight)
        layoutIfNeeded()
    }
}

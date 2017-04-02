//
//  AHPhotoBrowserCell.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/30/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit


class AHPhotoBrowserCell: UICollectionViewCell {
    @IBOutlet weak var scrollView: UIScrollView!
    
    weak var mainVC: UIViewController?
    var imageView = UIImageView()
    var image: UIImage? {
        didSet {
            if let image = image {
                setupImageView(image: image)
            }
        }
    }
    override func awakeFromNib() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.minimumZoomScale = 0.3;
        scrollView.maximumZoomScale = 6;
        scrollView.bouncesZoom = true
        scrollView.addSubview(imageView)
        scrollView.delegate = self
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHanlder(_:))))
    }
    
    func tapHanlder(_ sender: UITapGestureRecognizer){
        if let mainVC = mainVC {
            mainVC.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.minimumZoomScale = 0.5;
        scrollView.maximumZoomScale = 1.5;
        imageView.image = #imageLiteral(resourceName: "placeholder")
        if let image = image {
            setupImageView(image: image)
            scrollView.setZoomScale(1.0, animated: false)
        }
    }
    
    ///MARK:- This function is the part where you can then download HD image and set size and use this original smaller size image as a placeholder
    func setupImageView(image: UIImage) {
        let newFrame = AHPhotoBrowser.calculateImageSize(image: image)
        imageView.frame = newFrame
        imageView.image = image
        scrollView.contentSize = CGSize(width: mainScreenSize.width, height: newFrame.height)
        layoutIfNeeded()
    }
}


extension AHPhotoBrowserCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        UIView.animate(withDuration: 0.1, animations: {
//            self.imageView.center = .init(x: scrollView.bounds.width * 0.5, y: scrollView.bounds.height * 0.5)
//        }) { (_) in
//            self.scrollView.contentSize = CGSize(width: self.imageView.frame.size.width, height: self.imageView.frame.size.height)
//        }
//    }
//    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//        
//    }
    
}



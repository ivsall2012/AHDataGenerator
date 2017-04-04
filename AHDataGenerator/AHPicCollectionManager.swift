//
//  AHPicCollectionManager.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/31/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit

class AHPicCollectionManager: NSObject {
    weak var mainVC: UIViewController?
    weak var viewModel: AHCardViewModel?
    weak var pictureCollection: UICollectionView?
    weak var photoBrowserVC: AHPhotoBrowser?
    var animator = AHAnimator()
}

extension AHPicCollectionManager: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return viewModel?.pictureSize ?? CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        photoBrowserVC = storyboard.instantiateViewController(withIdentifier: "AHPhotoBrowser") as? AHPhotoBrowser
        
        if let photoBrowserVC = photoBrowserVC {
            animator.delegate = self
            animator.actingIndexPath = indexPath
            photoBrowserVC.transitioningDelegate = animator
            photoBrowserVC.modalPresentationStyle = .custom
            if viewModel.hasFinishedImageDownload {
                photoBrowserVC.viewModel = viewModel
                photoBrowserVC.currentIndexPath = indexPath
                mainVC?.present(photoBrowserVC, animated: true, completion: nil)
            }
        }
        
    }
    
    
}

extension AHPicCollectionManager: AHAnimatorDelegate {
    func AHAnimatorEndIndexPath() -> IndexPath {
        return photoBrowserVC!.currentIndexPath!
    }
    
    func AHAnimatorView(indexPath: IndexPath) -> UIView {
        let item = pictureCollection!.cellForItem(at: indexPath) as! AHPicCollectionCell
        let imageView = UIImageView(image: item.image)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    func AHAnimatorStartFrameFor(indexPath: IndexPath) -> CGRect {
        let item = pictureCollection!.cellForItem(at: indexPath) as! AHPicCollectionCell
        let rect = item.convert(item.pictureView.frame, to: UIApplication.shared.keyWindow!)
        return rect
    }
    func AHAnimatorEndFrameFor(indexPath: IndexPath) -> CGRect {
        let item = pictureCollection!.cellForItem(at: indexPath) as! AHPicCollectionCell
        let rect = AHPhotoBrowser.calculateImageSize(image: item.image!)
        return rect
    }
}

extension AHPicCollectionManager: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // it doesn't mater whether or not shouldPlaceholding since the pics count is the same
        return viewModel?.card?.pics?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! AHPicCollectionCell
        
        guard let viewModel = viewModel else {
            return cell
        }
        
        if viewModel.hasFinishedImageDownload {
            cell.image = viewModel.allImages[indexPath.item]
        }else{
            cell.image = #imageLiteral(resourceName: "placeholder")
        }
        
        return cell
    }
    @objc(collectionView:willDisplayCell:forItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}

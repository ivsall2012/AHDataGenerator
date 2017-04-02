//
//  AHPhotoBrowser.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/30/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit


let photoBrowserCellMargin: CGFloat = 5.0
let mainScreenSize: CGSize = UIScreen.main.bounds.size

private let reuseIdentifier = "AHPhotoBrowserCell"

class AHPhotoBrowser: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: AHCardViewModel?
    var currentIndexPath: IndexPath?


    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // You need to call this before scroll to item in order for collection view to layout its item cells, then scroll.
        self.view.layoutIfNeeded()
        
        if let currentIndexPath = currentIndexPath , viewModel != nil {
            collectionView.scrollToItem(at: currentIndexPath, at: UICollectionViewScrollPosition.right, animated: false)
        }
    }
    
    
    class func calculateImageSize(image: UIImage) -> CGRect {
        let imgSize = image.size
        let newWidth = mainScreenSize.width - 2 * photoBrowserCellMargin
        let newHeight = newWidth * imgSize.height / imgSize.width
        let newX : CGFloat = photoBrowserCellMargin
        var newY: CGFloat
        if newHeight > mainScreenSize.height {
            // log photo
            newY = 0.0
        }else{
            // photo can fit in the screen
            newY = (mainScreenSize.height - newHeight) * 0.5
        }
        let newFrame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        return newFrame
    }
    
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: UIButton) {
        print("saved photo")
    }

}

extension AHPhotoBrowser {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let items = collectionView.visibleCells
        if items.count == 1 {
            currentIndexPath = collectionView.indexPath(for: items.first!)
        }else{
            print("visible items have more then 1, problem?!")
        }
    }
}


extension AHPhotoBrowser: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

extension AHPhotoBrowser: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        guard viewModel.hasFinishedImageDownload else {
            return 0
        }
        return viewModel.allImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AHPhotoBrowserCell
        
        guard let viewModel = viewModel else {
            return cell
        }
        
        guard viewModel.hasFinishedImageDownload else {
            return cell
        }
        cell.mainVC = self
        cell.image = viewModel.allImages[indexPath.item]
        return cell
    }
}









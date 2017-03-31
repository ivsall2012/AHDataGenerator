//
//  AHPhotoBrowser.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/30/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit



private let reuseIdentifier = "AHPhotoBrowserCell"

class AHPhotoBrowser: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: AHCardViewModel?
//    {
//        didSet {
//            if viewModel != nil {
//                collectionView.reloadData()
//            }
//        }
//    }


    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
    }
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: UIButton) {
        print("saved photo")
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
        
        cell.image = viewModel.allImages[indexPath.item]
        return cell
    }
}









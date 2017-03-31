//
//  AHCardCellTableViewCell.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/29/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit

class AHCardCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var cardToolBar: UIView!
    @IBOutlet weak var pictureCollection: UICollectionView!
    @IBOutlet weak var mainTextHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pictureCollectionHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var gapBetweenTextAndPicsConstraint: NSLayoutConstraint!
    
    var placeholdingCount: Int = 9
    var mainVC: UIViewController?
    var viewModel: AHCardViewModel? {
        didSet{
            if let viewModel = viewModel {
                if let card = viewModel.card {
                    viewModel.goDownloadAvatar(completion: { (image) in
                        self.avatar.image = image
                    })
                    author.text = card.author
                    if let text = card.mainText, text.characters.count > 0 {
                        gapBetweenTextAndPicsConstraint.constant = padding
                        mainText.text = text
                        mainTextHeightConstraint.constant = viewModel.mainTextHeight
                    }else{
                        gapBetweenTextAndPicsConstraint.constant = 0.0
                        mainText.text = ""
                        mainTextHeightConstraint.constant = 0.0
                    }
                    if let pics = card.pics, pics.count > 0 {
                        pictureCollectionHeightConstraint.constant = viewModel.pictureCollectionHeight
                    }else{
                        gapBetweenTextAndPicsConstraint.constant = 0.0
                        pictureCollectionHeightConstraint.constant = 0.0
                    }
                    if viewModel.hasFinishedImageDownload {
                        pictureCollection.reloadData()
                    }else{
                        placeholdingCount = card.pics?.count ?? 0
                        self.pictureCollection.reloadData()
                        viewModel.goDownloadImages(completion: {[weak self] (_) in
                            if self?.viewModel !== viewModel {
                                print("this cell is currently being used by another viewModel. Return. Next time it should reload already downloaded images.")
                                return
                            }
                            self?.pictureCollection.reloadData()
                            self?.layoutIfNeeded()
                        })
                    }
                    layoutIfNeeded()
                }
                
                
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.image = #imageLiteral(resourceName: "placeholder")
        setupCollectionView()
    }
    
    func setupCollectionView() {
        pictureCollection.delegate = self
        pictureCollection.dataSource = self
        pictureCollection.contentInset = .zero
        let layout = pictureCollection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        layout.sectionInset = .init(top: 0, left: padding, bottom: 0, right: padding)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        mainText.text = ""
        avatar.image = #imageLiteral(resourceName: "placeholder")
        gapBetweenTextAndPicsConstraint.constant = 0.0
        mainTextHeightConstraint.constant = 0.0
        pictureCollectionHeightConstraint.constant = 0.0
    }
}



extension AHCardCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return viewModel?.pictureSize ?? CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AHPhotoBrowser") as! AHPhotoBrowser
        
        if viewModel.hasFinishedImageDownload {
            vc.viewModel = viewModel
            mainVC?.present(vc, animated: true, completion: nil)
        }
        
    }
    

}

extension AHCardCell: UICollectionViewDataSource {
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














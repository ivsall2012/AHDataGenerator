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
    weak var mainVC: UIViewController? {
        didSet{
            if let mainVC = mainVC {
                picCollectionMananger.mainVC = mainVC
            }
        }
    }
    
    // this is a dalagate/dataSource manager for picCollection
    var picCollectionMananger: AHPicCollectionManager = AHPicCollectionManager()
    
    // a viewModel for AHCardModel
    var viewModel: AHCardViewModel? {
        didSet{
            if let viewModel = viewModel {
                setupViewModel(viewModel: viewModel)
            }
        }
    }
    
    private func setupViewModel(viewModel: AHCardViewModel) {
        if let card = viewModel.card {
            picCollectionMananger.viewModel = viewModel
            // avatar image is cached
            viewModel.goDownloadAvatar(completion: { (image) in
                self.avatar.image = image
                
            })
            author.text = card.author
            
            layoutAdjustMents(card, viewModel)
            
            loadData(card, viewModel)
            
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAvatar()
        setupCollectionView()
    }
    
    

    override func prepareForReuse() {
        mainText.text = ""
        avatar.image = #imageLiteral(resourceName: "placeholder")
        gapBetweenTextAndPicsConstraint.constant = 0.0
        mainTextHeightConstraint.constant = 0.0
        pictureCollectionHeightConstraint.constant = 0.0
    }
}



///MARK: - Helper Functions
extension AHCardCell {
    
    fileprivate func setupAvatar() {
        avatar.image = #imageLiteral(resourceName: "placeholder")
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = avatarHeight * 0.5
        avatar.layer.borderColor = UIColor.orange.cgColor
        avatar.layer.borderWidth = 2.0
    }
    
    fileprivate func setupCollectionView() {
        picCollectionMananger.pictureCollection = self.pictureCollection
        pictureCollection.delegate = picCollectionMananger
        pictureCollection.dataSource = picCollectionMananger
        pictureCollection.contentInset = .zero
        let layout = pictureCollection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        
    }
    
    fileprivate func loadData(_ card: AHCardModel, _ viewModel: AHCardViewModel) {
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
    
    fileprivate func layoutAdjustMents(_ card: AHCardModel, _ viewModel: AHCardViewModel) {
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
    }
}













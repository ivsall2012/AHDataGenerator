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

    var mainVC: UIViewController?
    var cardModel: AHCardModel? {
        didSet{
            if let cardModel = cardModel {
                avatar.AH_setImage(urlStr: cardModel.avatar.absoluteString)
                author.text = cardModel.author
                if let text = cardModel.mainText, text.characters.count > 0 {
                    gapBetweenTextAndPicsConstraint.constant = padding
                    mainText.text = text
                    mainTextHeightConstraint.constant = cardModel.mainTextHeight
                }else{
                    gapBetweenTextAndPicsConstraint.constant = 0.0
                    mainText.text = ""
                    mainTextHeightConstraint.constant = 0.0
                }
                if let pics = cardModel.pics, pics.count > 0 {
                    pictureCollectionHeightConstraint.constant = cardModel.pictureCollectionHeight
                    print(pictureCollectionHeightConstraint.constant)
                }else{
                    gapBetweenTextAndPicsConstraint.constant = 0.0
                    pictureCollectionHeightConstraint.constant = 0.0
                }
//                print("\(cardModel.author)\ntextHeight:\(mainTextHeightConstraint.constant)\npicHeight:\(pictureCollectionHeightConstraint.constant)\ngap:\(gapBetweenTextAndPicsConstraint.constant)\n totle:\(cardModel.cellHeight)\n=====\n")
                pictureCollection.reloadData()
                layoutIfNeeded()
                
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
        print("setSelected")
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
        return cardModel!.pictureSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AHPhotoBrowser") as! AHPhotoBrowser
        let model = cardModel!.pics
        vc.photos = model
        mainVC?.present(vc, animated: true, completion: nil)
    }

    
}

extension AHCardCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardModel?.pics?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! AHPicCollectionCell
        let pics = cardModel!.pics!
        cell.backgroundColor = UIColor.red
        cell.imageStr = pics[indexPath.item]
        return cell
    }
}














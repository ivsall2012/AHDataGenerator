//
//  AHCardModel.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/29/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit
let padding: CGFloat = 8.0
let avatarHeight: CGFloat = 90.0
let authorHeight: CGFloat = 20.5
let cardToolBarHeight: CGFloat = 33.0
let pictureMaxWidth: CGFloat = UIScreen.main.bounds.width - 8.0 * 4
let pictureMaxHeight: CGFloat = 300.0
class AHCardModel: NSObject {

    
    var cellHeight: CGFloat = 0.0
    var pictureSize: CGSize = CGSize.zero
    
    
    var author: String
    var avatar: URL
    var mainText: String?
    var pics: [String]?
    
    var mainTextHeight: CGFloat = 0.0
    var pictureCollectionHeight: CGFloat = 0.0
    init(dict: [String: Any]) {
        cellHeight = padding + avatarHeight + padding + authorHeight + padding + cardToolBarHeight
        self.author = dict["author"] as! String
        let avatarStr = dict["avatar"] as! String
        self.avatar = URL(string: avatarStr)!
        let mainText = dict["mainText"] as? String
        if mainText != nil && mainText!.characters.count > 0 {
            self.mainText = mainText!
            let screenWidth = UIScreen.main.bounds.width
            let maxSize = CGSize(width: screenWidth - 2*8, height: CGFloat(DBL_MAX))
            let font = UIFont.systemFont(ofSize: 17)
            let height = (mainText! as NSString).boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).height + 10.0
            mainTextHeight = height
            cellHeight += (padding + mainTextHeight)
        }
        
        let picStrArr = dict["pics"] as? [String]
        if picStrArr != nil {
            var pics = [String]()
            for picStr in picStrArr! {
                pics.append(picStr)
            }
            let maxWidth = pictureMaxWidth - (2 * padding)
            let newWidth = maxWidth / 3
            let newHeight = newWidth
            let numOfRows = CGFloat(((pics.count-1) / 3)) + 1
            pictureCollectionHeight = numOfRows * newHeight + (numOfRows - 1)*padding
            pictureSize = CGSize(width: newWidth, height: newHeight)
            cellHeight += (padding + pictureCollectionHeight)
            self.pics = pics
            
        }
        
        
    }
    func calculatePictureSize(images: [UIImage]) {
        if images.count == 1 {
            // using pictureMaxWidth as newWidth to maximize image
            let imgSize = images.first!.size
            let newHeight = imgSize.height * pictureMaxWidth / imgSize.width
            pictureSize = CGSize(width: pictureMaxWidth, height: newHeight)
            pictureCollectionHeight = newHeight
            return
        }
        
        if images.count == 4 {
            // forming a 2x2 square
            let maxWidth = pictureMaxWidth - padding
            let newWidth = maxWidth / 2
            let newHeight = newWidth
            pictureSize = CGSize(width: pictureMaxWidth, height: newHeight)
            pictureCollectionHeight = newHeight * 2 + padding
            return
        }
        
        if (images.count > 1 && images.count <= 9) {
            // treating 2 or 3, 5 images like there are 3 images in a row
            let maxWidth = pictureMaxWidth - (2 * padding)
            let newWidth =  maxWidth / CGFloat(images.count)
            let newHeight = newWidth
            pictureSize = CGSize(width: pictureMaxWidth, height: newHeight)
            let numOfRows = CGFloat((images.count % 3) + 1)
            pictureSize = CGSize(width: maxWidth, height: newHeight)
            pictureCollectionHeight = numOfRows * newHeight + (numOfRows - 1)*padding
            return
        }
        
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        var picCount: Int = 0
        if self.pics != nil {
            picCount = self.pics!.count
        }
        return "author:\(author)\nmainText:\(mainText)\nnumOfpics:\(picCount)"
    }
    
}

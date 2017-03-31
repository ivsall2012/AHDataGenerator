//
//  AHCardViewModel.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/30/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit
let padding: CGFloat = 8.0
let avatarHeight: CGFloat = 90.0
let cardToolBarHeight: CGFloat = 49.0
let pictureMaxWidth: CGFloat = UIScreen.main.bounds.width - padding * 4


class AHCardViewModel: NSObject {
    var cellHeight: CGFloat = 0.0
    var pictureSize: CGSize = CGSize.zero
    var mainTextHeight: CGFloat = 0.0
    var pictureCollectionHeight: CGFloat = 0.0
    
    var hasFinishedImageDownload = false
    var allImages = [UIImage]()
    var avatar: UIImage?
    fileprivate var imageDownloadhandler: ((_ finished: Bool)->Swift.Void)?
    var card: AHCardModel? {
        didSet {
            if let card = card {
                
                cellHeight = padding + avatarHeight + padding + cardToolBarHeight
                
                if let mainText = card.mainText, mainText.characters.count > 0 {
                    let screenWidth = UIScreen.main.bounds.width
                    let maxSize = CGSize(width: screenWidth - 2*padding, height: CGFloat(DBL_MAX))
                    let font = UIFont.systemFont(ofSize: 17)
                    let height = (mainText as NSString).boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).height + 10.0 // <-- this extra 10 is for UILabel padding
                    mainTextHeight = height
                    cellHeight += (padding + mainTextHeight)
                }
                
                if let pics = card.pics, pics.count > 0 {
                    let maxWidth = pictureMaxWidth - (2 * padding)
                    let newWidth = maxWidth / 3
                    let newHeight = newWidth
                    let numOfRows = CGFloat(((pics.count-1) / 3)) + 1
                    pictureCollectionHeight = numOfRows * newHeight + (numOfRows - 1)*padding
                    pictureSize = CGSize(width: newWidth, height: newHeight)
                    cellHeight += (padding + pictureCollectionHeight)
                }

            }
        }
    }
    
    func goDownloadAvatar(completion:@escaping (_ image: UIImage)->Swift.Void){
        if avatar != nil {
            completion(avatar!)
            return
        }
        
        guard let card = card else {
            completion(#imageLiteral(resourceName: "placeholder"))
            return
        }
        
        AHNetowrkTool.tool.requestImage(urlStr: card.avatarUrl!, completion: { (image) in
            if let image = image {
                self.avatar = image
                completion(image)
                return
            }
            completion(#imageLiteral(resourceName: "placeholder"))
        })
        
    }

    
    /// You should call allImages to load all images for views
    func goDownloadImages(completion: @escaping (_ finished: Bool)->Swift.Void) {
        guard card != nil else {
            print("AHCardViewModel scard is nil")
            return
        }
        guard card!.pics != nil else {
            hasFinishedImageDownload = true
            return
        }
        guard let pics = card!.pics else {
            return
        }
        
        self.imageDownloadhandler = completion
        downloadAllImages(pics: pics)
    }
    
    
}

///MARK:- Networking
extension AHCardViewModel {
    fileprivate func downloadAllImages(pics: [String]) {
        let group = DispatchGroup()
        
        for pic in pics {
            group.enter()
            AHNetowrkTool.tool.requestImage(urlStr: pic, completion: { (image) in
                group.leave()
                if image != nil {
                    self.allImages.append(image!)
                }else{
                    print("AHCardViewModel web image nil")
                }
            })
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.hasFinishedImageDownload = true
            if self.allImages.count == pics.count {
                self.imageDownloadhandler?(true)
            }else{
                print("AHCardViewModel image counts don't match after fnished downloading")
            }
            
        }
        
    }
}

extension AHCardViewModel {
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
}



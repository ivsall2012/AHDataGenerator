//
//  AHCardDataGenerator.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/29/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit

public class AHCardDataGenerator: NSObject {
    static let generator =  AHCardDataGenerator()
    let shouldUseLocalImages = false
    let randomPicURL = "http://lorempixel.com/400/200"
    let randomPicHolder = "http://placehold.it/350x150"
    let anotherPlaceHolder = "https://placeimg.com/640/480/any"
    
    let paragraph = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua Ut enim ad minim veniam. "
    
    let userAvatars = ["https://firebasestorage.googleapis.com/v0/b/localfun-c9f46.appspot.com/o/internal-user-icons%2Fuser-icon-1.png?alt=media&token=c197a8dc-6176-4af8-98b5-0658a5e0846a",
    "https://firebasestorage.googleapis.com/v0/b/localfun-c9f46.appspot.com/o/internal-user-icons%2Fuser-icon-2.jpg?alt=media&token=6beea959-af9b-408f-8aed-b5431af943d3",
    "https://firebasestorage.googleapis.com/v0/b/localfun-c9f46.appspot.com/o/internal-user-icons%2Fuser-icon-2.png?alt=media&token=2bdbc9f6-86de-4899-a5d7-120c960d1c68",
    "https://firebasestorage.googleapis.com/v0/b/localfun-c9f46.appspot.com/o/internal-user-icons%2Fuser-icon-3.png?alt=media&token=1778371e-d11e-4b62-8123-8390ba7f478a",
    "https://firebasestorage.googleapis.com/v0/b/localfun-c9f46.appspot.com/o/internal-user-icons%2Fuser-icon-4.jpg?alt=media&token=9668430f-b33f-4f11-8e62-f4505bf1757b",
    "https://firebasestorage.googleapis.com/v0/b/localfun-c9f46.appspot.com/o/internal-user-icons%2Fuser-icon-100-done.png?alt=media&token=ba219d2b-dc99-4b4d-a661-201e3ce41a60",
    "https://firebasestorage.googleapis.com/v0/b/localfun-c9f46.appspot.com/o/internal-user-icons%2Fuser-icon-102-done.png?alt=media&token=0acb9659-4c19-49f7-a9d3-cc7ea595a4e4",
    "https://firebasestorage.googleapis.com/v0/b/localfun-c9f46.appspot.com/o/internal-user-icons%2Fuser-icon-101-done.png?alt=media&token=f2ca4770-47b4-45f5-9765-d5fbfd2b558a",
    "https://firebasestorage.googleapis.com/v0/b/localfun-c9f46.appspot.com/o/internal-user-icons%2Fuser-icon-103-done.png?alt=media&token=afad647c-b482-41b6-9cd7-441c5c1f958d"]
    
    let picGallery = ["Alaska", "California", "Colorado", "Utah", "Washington","California", "Colorado", "Alaska", "California"]
    
    
    
}


extension AHCardDataGenerator{
    func randomData() -> [AHCardViewModel] {
        let cards = randomCardBatch()
        var viewModelArr = [AHCardViewModel]()
        for card in cards {
            let viewModel = AHCardViewModel()
            viewModel.card = card
            viewModelArr.append(viewModel)
        }
        return viewModelArr
    }
    
    
    func randomCardBatch() -> [AHCardModel] {
        var data = [AHCardModel]()
//        let numOfCards = random(20)
        for _ in 0..<100 {
            let dict = randomCard()
            let card = AHCardModel(dict: dict)
            data.append(card)
        }
        return data
    }
    
    
    func randomCard() -> [String: Any]{
        var dict = [String: Any]()
        
        let userDict = randomUserProfile()
        dict = userDict
        
        
        
        // 85% chance for having a main text
        if randomPercentChance(percent: 0) {
            let smalText = random(0, 3)
            let bigText = random(3, 5)
            // it has 60% chance to have smal text
            let numOfParagraphs = randomPercentChance(percent: 60) ? smalText : bigText
            var mainText: String = ""
            for _ in 0..<numOfParagraphs {
                mainText.append(paragraph)
            }
            dict["mainText"] = mainText
        }
        
        if shouldUseLocalImages {
            // 70% chance for having a pic gallery
            if randomPercentChance(percent: 100) {
                let numOfPics = random(1, 10)
                var pics = [String]()
                for _ in 0..<numOfPics {
                    let index = random(picGallery.count)
                    let picURL = picGallery[index]
                    pics.append(picURL)
                }
                dict["pics"] = pics
            }
            
        }else{
            
            let numOfPics = random(1, 10)
            var pics = [String]()
            for _ in 0..<numOfPics {
                let width = 100 * random(1, 6)
                let height = 100 * random(1, 6)
//                let imageUrl = "http://lorempixel.com/\(width)/\(height)"
//                let imageUrl = "http://placehold.it/\(width)x\(height)"
                let imageUrl = "https://placeimg.com/\(width)/\(height)/any"
                pics.append(imageUrl)
            }
            dict["pics"] = pics
        }
        
        
        return dict
        
    }
    
    func randomUserProfile() -> [String : Any] {
        var dict = [String : Any]()
        let name = randomName(with: "The Generator")
        dict["author"] = name
        
        let userAvatar = userAvatars[random(userAvatars.count)]
        dict["avatar"] = userAvatar
        
        return dict
    }
    
}




//MARK:- For random helper
extension AHCardDataGenerator {
    
    func randomName(with prefix: String) -> String {
        let num = random(999)
        return "\(prefix) \(num) "
    }
    
    func randomPercentChance(percent: Int) -> Bool {
        let randomNum = random(100)
        if randomNum < percent {
            return true
        }else{
            return false
        }
    }
    
    func randomBool() -> Bool {
        let rand = arc4random_uniform(100)
        return rand % 2 == 0 ? true : false
    }
    
    func random(_ ceil: Int) -> Int {
        return Int(arc4random_uniform(UInt32(ceil)))
    }
    
    func random(_ floor: Int, _ ceil: Int) -> Int {
        guard floor < ceil else {
            return -1
        }
        return Int(arc4random_uniform(UInt32(ceil - floor))) + floor
    }
}









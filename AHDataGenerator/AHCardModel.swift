//
//  AHCardModel.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/29/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit




class AHCardModel: NSObject {

    

    
    var author: String
    var avatarUrl: String?
    var mainText: String?
    var pics: [String]?
    

    init(dict: [String: Any]) {
        
        self.author = dict["author"] as! String
        avatarUrl = dict["avatar"] as? String
        if let mainText = dict["mainText"] as? String {
            self.mainText = mainText
        }
        
        
        let picStrArr = dict["pics"] as? [String]
        if picStrArr != nil {
            var pics = [String]()
            for picStr in picStrArr! {
                pics.append(picStr)
            }
            self.pics = pics
            
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

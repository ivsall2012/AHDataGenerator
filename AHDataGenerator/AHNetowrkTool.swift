//
//  AHNetowrkTool.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/29/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit

let shouldCacheImage = true

class AHNetowrkTool: NSObject {
    static let tool = AHNetowrkTool()
    
    func requestImage(urlStr: String, completion: @escaping (_ image: UIImage?) -> Swift.Void) {
        guard let url = URL(string: urlStr) else {
            return
        }
//        if shouldCacheImage {
//            let cacheSizeMemory = 500 * 1024 * 1024; // 500 MB
//            let cacheSizeDisk = 500 * 1024 * 1024; // 500 MB
//            let sharedCache = URLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: "urlCache")
//            URLCache.shared = sharedCache
//            let config = URLSession.shared.configuration
//            config.requestCachePolicy = .returnCacheDataElseLoad
//        }else{
//            let config = URLSession.shared.configuration
//            config.requestCachePolicy = .reloadIgnoringLocalCacheData
//        }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                if let data = data, error == nil {
                    if let image = UIImage(data: data) {
                        completion(image)
                        return
                    }
                    
                }
                completion(nil)
            }
        }
        DispatchQueue.global().async {
            task.resume()
        }
    }
}

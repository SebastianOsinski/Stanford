//
//  ImageService.swift
//  Smashtag
//
//  Created by Sebastian Osiński on 18.12.2015.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class ImageService {
    
    static let sharedInstance = ImageService()
    
    private let imageCache: NSCache
    
    private init() {
        imageCache = NSCache()
    }
    
    func fetchImageFromURL(url: NSURL, handler: (UIImage?) -> Void) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            var image: UIImage? = nil
            if let cachedImage = self.imageCache.objectForKey(url) as? UIImage {
                image = cachedImage
            } else if let imageData = NSData(contentsOfURL: url),
                let image = UIImage(data: imageData) {
                    
                self.imageCache.setObject(image, forKey: url)
            }
            handler(image)
        }
    }
}
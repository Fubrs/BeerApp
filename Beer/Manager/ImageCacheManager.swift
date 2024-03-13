//
//  ImageCacheManager.swift
//  Beer
//
//  Created by Nikita Chuklov on 12.03.2024.
//

import UIKit

class ImageCacheManager: NSObject {
    private var cache: NSCache<NSString, UIImage> = NSCache()
    
    override init() {
        super.init()
    }
    
    
    func saveImage(_ image: UIImage?, forKey key: NSString) {
        cache[key] = image
    }
    
    func image(for url: NSString) -> UIImage? {
        return cache[url]
    }
}

//
//  AppComponents.swift
//  Beer
//
//  Created by Nikita Chuklov on 12.03.2024.
//

import Foundation

class AppComponents {
    lazy var apiManager: ApiManagerProtocol = {
        return ApiManager()
    }()
    
    lazy var imageCache: ImageCacheManager = {
        return ImageCacheManager()
    }()
}

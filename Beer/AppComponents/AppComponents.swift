//
//  AppComponents.swift
//  Beer
//
//  Created by Nikita Chuklov on 12.03.2024.
//

import Foundation

class AppComponents {
    /// Provide the url for fetching requests
    lazy var apiManager: ApiManagerProtocol = {
        return ApiManager()
    }()
    /// Provide image store and remove actions
    lazy var imageCache: ImageCacheManager = {
        return ImageCacheManager()
    }()
}

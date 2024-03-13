//
//  apiManager.swift
//  Beer
//
//  Created by Nikita Chuklov on 10.03.2024.
//

import UIKit


protocol ApiManagerProtocol {
    func url(for endpoint: Endpoint) -> URL?
}

enum Endpoint {
    case page(Int)
    case name(String)
}

class ApiManager: ApiManagerProtocol {
    //MARK: - Private properties
    
    private let defaultPaginationCount = 20
    
    //MARK: - Functions
    
    func url(for endpoint: Endpoint) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.punkapi.com"
        urlComponents.path = "/v2/beers"
        
        var queryItems: [URLQueryItem] = []
        
        switch endpoint {
        case .page(let page):
            let pageQuery = URLQueryItem(name: "page", value: "\(page)")
            let perPageQuery = URLQueryItem(name: "per_page", value: "\(defaultPaginationCount)")
            queryItems.append(contentsOf: [pageQuery, perPageQuery])
        case .name(let name):
            let nameQuery = URLQueryItem(name: "beer_name", value: name)
            queryItems.append(nameQuery)
        }
        
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
    
}


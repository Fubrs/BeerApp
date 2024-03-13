//
//  Beer.swift
//  Beer
//
//  Created by Nikita Chuklov on 10.03.2024.
//

import Foundation

// MARK: - BeerElement
struct Beer: Codable {
    /// Identifier of the beer
    let id: Int
    /// Name of beer
    let name, firstBrewed, description: String
    let imageURL: String?
    let abv: Double
    let foodPairing: [String]

    enum CodingKeys: String, CodingKey {
        case id, name
        case firstBrewed = "first_brewed"
        case description
        case imageURL = "image_url"
        case abv
        case foodPairing = "food_pairing"
    }
}


//
//  MenuItem.swift
//  myRestaurant
//
//  Created by IOSLAB INGENIERIA on 24/01/23.
//

import Foundation

//define the model
struct menuItem: Codable {
    var id: Int
    var name: String
    var detailText: String
    var price: Double
    var category : String
    var imageURL: URL
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case detailText = "description"
        case price
        case category
        case imageURL = "image_url"
    }
    
}


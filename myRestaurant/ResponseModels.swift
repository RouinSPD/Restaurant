//
//  ResponseModels.swift
//  myRestaurant
//
//  Created by IOSLAB INGENIERIA on 24/01/23.
//

import Foundation
//define the models

struct menuResponse: Codable{
    
    let items: [menuItem]
}

struct categoryResponse: Codable{
    let categories: [String]
}

struct orderResponse: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey{
        case prepTime = "preparation_time"
    }
}



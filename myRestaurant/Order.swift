//
//  Order.swift
//  myRestaurant
//
//  Created by IOSLAB INGENIERIA on 24/01/23.
//

import Foundation
// define de model
struct Order: Codable{
    var menuItems : [menuItem]
    
    init(menuItems: [menuItem] = []) {
        self.menuItems = menuItems
    }
    }

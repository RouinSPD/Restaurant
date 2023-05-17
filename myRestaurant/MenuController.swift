//
//  MenuController.swift
//  myRestaurant
//
//  Created by IOSLAB INGENIERIA on 24/01/23.
//

import Foundation

class MenuController {
    static let shared = MenuController()
    var order = Order(){
        didSet{
            NotificationCenter.default.post(
                name: MenuController.orderUpdateNotification,
                object: nil)
        }
    }
    static let orderUpdateNotification = Notification.Name("MenuController.orderUpdated")
    
    //all the network calls use the same host
    let baseURL = URL(string: "http://localhost:8080/")!
    
    enum MenuControllerError: Error, LocalizedError{
        case categoriesNotFound
        case menuItemsNotFound
        case orderRequestFailed
        
    }
    
    func fetchCategories() async throws -> [String]{
        //complete the URL appending the endpoint
        let categoriesURL = baseURL.appendingPathComponent("categories")
        //submit request
        let (data, response) = try await URLSession.shared.data(from: categoriesURL)
        
        //check response and throw and error if needed
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
        else {
            throw MenuControllerError.categoriesNotFound
        }
        //decode into a categories response
        let decoder = JSONDecoder()
        let categoriesResponse = try decoder.decode(categoryResponse.self, from: data)
        
        //return an array of strings with the categories
        return categoriesResponse.categories
    }
    
    func fetchMenuItems(forCategory categoryName: String) async throws ->[menuItem]{
        //complete the URL appending the endpoint
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        //add the query parameter
        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        let menuURL = components.url!
        //submit the request
        let (data, response) = try await URLSession.shared.data(from: menuURL)
        //check response and throw and error if needed
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
        else {
            throw MenuControllerError.menuItemsNotFound
        }
        //decode into a menu response
        let decoder = JSONDecoder()
        let menuItemsResponse = try decoder.decode(menuResponse.self, from: data)
        
        //return an array of menu items
        return menuItemsResponse.items
        
        
    }
    
    //the number of minutes it takes to prepare an order
    typealias MinutesToPrepare = Int
    
    func submitOrder(forMenuIds menuIds: [Int]) async throws -> MinutesToPrepare{
        //complete the URL appending the endpoint
        let orderURL = baseURL.appendingPathComponent("order")
        
        var request = URLRequest(url: orderURL)
        //modify the request type
        request.httpMethod = "POST"
        //sending JSON data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //store the arrays of menu IDS in JSON
        let menuIdsDict = ["menuIds" : menuIds]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(menuIdsDict)
        
        //store the data in the body of the request
        request.httpBody = jsonData
        
        //request has 2 parts, method & body
        //submit the request
        let(data, response) = try await URLSession.shared.data(for: request)
        //check response and throw and error if needed
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
        else{
            throw MenuControllerError.orderRequestFailed
        }
        //decode into an order response
        let decoder = JSONDecoder()
        let orderResponse = try decoder.decode(orderResponse.self, from: data)
        
        //return number of minutes for the ordered to be prepared
        return orderResponse.prepTime
    }
}

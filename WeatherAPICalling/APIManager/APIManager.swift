//
//  APIManager.swift
//  WeatherAPICalling
//
//  Created by Arpit iOS Dev. on 06/06/24.
//

import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func postWeatherData(queryParams: [String: String], completion: @escaping (Result<Data?, AFError>) -> Void) {
        let baseURL = "http://api.weatherstack.com/current"
        
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let finalURL = urlComponents?.url else {
            print("Error constructing URL with query parameters")
            return
        }
        
        AF.request(finalURL, method: .post, parameters: queryParams, encoding: JSONEncoding.default)
            .validate()
            .response { response in
                completion(response.result)
            }
    }
}

//
//  Endpoint.swift
//  UpcomingMovies
//
//  Created by Alonso on 11/6/18.
//  Copyright © 2018 Alonso. All rights reserved.
//

import Foundation

protocol Endpoint {
    
    var base: String { get }
    var path: String { get }
    var params: [String: Any]? { get }
    var parameterEncoding: ParameterEnconding { get }
    var method: HTTPMethod { get }
    
}

extension Endpoint {
    
    var apiKey: String {
        return "0141e6d543b187f0b7e6bb3a1902209a"
    }
    
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        switch parameterEncoding {
        case .defaultEncoding:
            if let params = params, method == .get {
                queryItems.append(contentsOf: params.map {
                    return URLQueryItem(name: "\($0)", value: "\($1)")
                })
            }
        case .compositeEncoding, .compositeJSONEncoding:
            if let params = params,
                let queryParams = params["query"] as? [String: Any] {
                queryItems.append(contentsOf: queryParams.map {
                    return URLQueryItem(name: "\($0)", value: "\($1)")
                })
            }
        }
        
        components.queryItems = queryItems
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        guard let params = params, method != .get else { return request }
        
        switch parameterEncoding {
        case .defaultEncoding:
            request.httpBody = params.percentEscaped().data(using: .utf8)
        case .compositeEncoding:
            if let bodyParams = params["body"] as? [String: Any] {
                request.httpBody = bodyParams.percentEscaped().data(using: .utf8)
            }
        case .compositeJSONEncoding:
            if let bodyParams = params["body"] as? [String: Any] {
                request.setJSONContentType()
                let jsonData = try? JSONSerialization.data(withJSONObject: bodyParams)
                request.httpBody = jsonData
            }
        }
        
        return request
    }
    
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum ParameterEnconding {
    case defaultEncoding
    case compositeEncoding
    case compositeJSONEncoding
}

//
//  RedditEnpoints.swift
//  TopRedditApp
//
//  Created by Carlos Mendoza on 3/4/24.
//

import Foundation

enum PostEndpoints: Endpoint {
    
    case top(String?)
    case information(String, String)
    
    var requestTimeOut: Float {
        return 60.0
    }
    
    var httpMethod: HTTPMethod {
        switch self {
            case .top, .information: return .GET
        }
    }
    
    var contentType: String {
        switch self {
            case .top, .information: return "application/json"
        }
    }
    
    func createRequest(baseURL: String, cachePolicy: URLRequest.CachePolicy) -> NetworkRequest {
        return NetworkRequest(url: getURL(with: baseURL), headers: [:], reqBody: requestBody, reqTimeout: requestTimeOut, httpMethod: httpMethod, contentType: contentType, cachePolicy: cachePolicy)
    }
    
    var requestBody: Data? {
        switch self {
            case .top, .information: return nil
        }
    }
    
    func getURL(with baseURL: String) -> String {
        switch self {
            case .top(let after):
                var url = baseURL + "/top.json?limit=\(Application.Configuration.topPostSliceLimit)"
                url += after != nil ? "&after=\(after!)" : ""
                return url
            
            case .information(let subreddit, let subredditId): return baseURL + "/r/\(subreddit)/api/info.json?id=\(subredditId)"
        }
    }
}

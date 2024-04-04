//
//  NetworkRequest.swift
//  TopRedditApp
//
//  Created by Carlos Mendoza on 3/4/24.
//

import Foundation

struct NetworkRequest {
    
    let url: String
    let headers: [String: String]?
    let body: Data?
    let requestTimeOut: Float
    let httpMethod: HTTPMethod
    let contentType: String
    let cachePolicy: URLRequest.CachePolicy
    
    init(url: String, headers: [String: String]? = nil, reqBody: Encodable? = nil, reqTimeout: Float, httpMethod: HTTPMethod, contentType: String, cachePolicy: URLRequest.CachePolicy) {
        self.url = url
        self.headers = headers
        self.body = reqBody?.encode()
        self.requestTimeOut = reqTimeout
        self.httpMethod = httpMethod
        self.contentType = contentType
        self.cachePolicy = cachePolicy
    }
    
    func buildURLRequest(with url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers ?? [:]
        urlRequest.httpBody = body
        urlRequest.timeoutInterval = TimeInterval(requestTimeOut)
        urlRequest.cachePolicy = cachePolicy
        urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
}

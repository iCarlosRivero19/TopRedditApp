//
//  EndPoint.swift
//  TopRedditApp
//
//  Created by Carlos Mendoza on 3/4/24.
//

import Foundation

internal protocol Endpoint {
    var requestTimeOut: Float { get }
    var httpMethod: HTTPMethod { get }
    var requestBody: Data? { get }
    func getURL(with baseURL: String) -> String
}

typealias Headers = [String: String]

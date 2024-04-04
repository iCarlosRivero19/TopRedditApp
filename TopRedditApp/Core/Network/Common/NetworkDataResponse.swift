//
//  NetworkDataResponse.swift
//  TopRedditApp
//
//  Created by Carlos Mendoza on 3/4/24.
//

import Foundation

public struct NetworkDataResponse<T>: Codable where T: Codable {
    public let data: T
}

//
//  RDTError.swift
//  TopRedditApp
//
//  Created by Carlos Mendoza on 3/4/24.
//

import Foundation

public enum NetworkError: String, Error, Equatable {
    case networkBadURL
    case networkInvalidJSON
    case networkUnauthorized
    case networkBadRequest
    case networkServerError
    case networkClientError
    case networkUnknown
}

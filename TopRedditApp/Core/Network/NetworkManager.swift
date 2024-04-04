//
//  NetworkManager.swift
//  TopRedditApp
//
//  Created by Carlos Mendoza on 3/4/24.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    func request<T: Codable>(_ req: NetworkRequest) -> AnyPublisher<T, NetworkError>
}

internal class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    
    func request<T>(_ req: NetworkRequest) -> AnyPublisher<T, NetworkError>
    where T: Decodable, T: Encodable {
        
        guard let url = URL(string: req.url) else {
            return AnyPublisher(
                Fail<T, NetworkError>(error: NetworkError.networkBadURL)
            )
        }
        return URLSession.shared
            .dataTaskPublisher(for: req.buildURLRequest(with: url))
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw NetworkError.networkServerError
                }
    
                switch response.statusCode {
                    case 200...299: return output.data
                    case 400: throw NetworkError.networkClientError
                    case 401, 403: throw NetworkError.networkUnauthorized
                    case 404...499: throw NetworkError.networkClientError
                    case 500...599: throw NetworkError.networkServerError
                    default: throw NetworkError.networkUnknown
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                guard let rdtError = error as? NetworkError else {
                    return NetworkError.networkInvalidJSON
                }
                return rdtError
            }
            .eraseToAnyPublisher()
    }
    
    private init() {}
}

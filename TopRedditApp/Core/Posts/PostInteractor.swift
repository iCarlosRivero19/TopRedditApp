//
//  RedditInteractor.swift
//  TopRedditApp
//
//  Created by Carlos Mendoza on 3/4/24.
//

import Foundation
import Combine

public class PostInteractor {
    
    private let network: NetworkManager
    internal var cancellables = Set<AnyCancellable>()
    
    init(network: NetworkManager = NetworkManager.shared) {
        self.network = network
    }
    
    func fetchTop(after: String?) -> AnyPublisher<NetworkDataResponse<RedditResponse<Post>>, NetworkError> {
        let cachePolicy: URLRequest.CachePolicy = after != nil ? .reloadIgnoringCacheData : .returnCacheDataElseLoad
        let request = PostEndpoints.top(after).createRequest(baseURL: Application.Configuration.baseURL, cachePolicy: cachePolicy)
        return network.request(request)
    }
    
    func info(subreddit: String, subredditId: String) -> AnyPublisher<NetworkDataResponse<RedditResponse<PostInfo>>, NetworkError> {
        let request = PostEndpoints.information(subreddit, subredditId).createRequest(baseURL: Application.Configuration.baseURL, cachePolicy: .reloadIgnoringCacheData)
        return network.request(request)
    }
}

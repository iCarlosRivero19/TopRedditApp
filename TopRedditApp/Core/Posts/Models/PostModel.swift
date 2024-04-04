//
//  Reedit.swift
//  TopRedditApp
//
//  Created by Carlos Mendoza on 3/4/24.
//

import Foundation

struct Post: Codable, Hashable {
    let title: String?
    let author: String?
    let created: Double?
    let thumbnail: String?
    let subreddit: String
    let subredditId: String
    let subredditDisplay: String?
    let numComments: Int?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case author
        case created = "created_utc"
        case thumbnail
        case subreddit
        case subredditId = "subreddit_id"
        case subredditDisplay = "subreddit_name_prefixed"
        case numComments = "num_comments"
    }
}

struct RedditResponse<T>: Codable where T: Codable {
    let before: String?
    let after: String?
    let children: [NetworkDataResponse<T>]
}

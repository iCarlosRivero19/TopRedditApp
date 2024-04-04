//
//  RedditInfoModel.swift
//  TopRedditApp
//
//  Created by Carlos Mendoza on 3/4/24.
//

import Foundation

struct PostInfo: Codable {
    let description: String?
    let icon: String?
    
    private enum CodingKeys: String, CodingKey {
        case description
        case icon = "icon_img"
    }
}

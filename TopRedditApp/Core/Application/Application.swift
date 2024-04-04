//
//  Application.swift
//  TopRedditApp
//
//  Created by Carlos Mendoza on 3/4/24.
//

import Foundation

struct Application {
    
    struct Configuration {
        static var baseURL: String = "https://www.reddit.com"
        static let redditPostDateFormat: String = "MM/dd/yyyy"
        static let defaultLocale: String = "en_US_POSIX"
        static let topPostSliceLimit: Int = 10
    }
}

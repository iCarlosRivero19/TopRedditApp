//
//  Date.swift
//  TopRedditApp
//
//  Created by Carlos Mendoza on 3/4/24.
//

import Foundation

extension Date {
    
    static func redditPostDateFormat(unix: Double) -> String {
        let format = Application.Configuration.redditPostDateFormat
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Application.Configuration.defaultLocale)
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: Date(timeIntervalSince1970: unix))
    }
}

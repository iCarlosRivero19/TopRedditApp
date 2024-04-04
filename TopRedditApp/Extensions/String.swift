//
//  String.swift
//  TopRedditApp
//
//  Created by Carlos Mendoza on 3/4/24.
//

import Foundation
import UIKit

extension String {
    
     func numCommentsAttibutedString() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: "")
    
        let icon = NSTextAttachment()
        icon.image = UIImage(systemName: "bubble.left.and.bubble.right")
        icon.bounds = CGRect(x: 0, y: -3, width: 22, height: 18)
        let iconString = NSAttributedString(attachment: icon)
        
        attributedString.append(iconString)
        attributedString.append(NSMutableAttributedString(string: " " + self))
        
        return attributedString
    }
}

//
//  PostCellModel.swift
//  TopRedditApp
//
//  Created by Carlos Mendoza on 4/4/24.
//

import Foundation

enum TopPostSection : Hashable {
    case main
}

enum TopPostCellEvent {
    case selected(Post)
}

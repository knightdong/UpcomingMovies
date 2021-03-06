//
//  Review.swift
//  UpcomingMovies
//
//  Created by Alonso on 2/11/19.
//  Copyright © 2019 Alonso. All rights reserved.
//

import Foundation

struct Review: Decodable, Equatable {
    
    let id: String
    let authorName: String
    let content: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case authorName = "author"
        case content
    }
    
}

// MARK: - Test mockups

extension Review {
    
    static func with(id: String = "1",
                     authorName: String = "ABC",
                     content: String = "Video1") -> Review {
        return Review(id: id, authorName: authorName, content: content)
    }
    
}

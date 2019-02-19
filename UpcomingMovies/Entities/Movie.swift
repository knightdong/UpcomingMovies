//
//  Movie.swift
//  UpcomingMovies
//
//  Created by Alonso on 11/6/18.
//  Copyright © 2018 Alonso. All rights reserved.
//

import Foundation

struct Movie: Decodable, Equatable {
    
    let id: Int
    let title: String
    let genres: [Int]?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double?
    
    static let posterAspectRatio: Double = 1.5
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case genres = "genre_ids"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }

}

extension Movie {
    
    var genreName: String {
        guard let genres = genres,
            !genres.isEmpty,
            let genre = genres.first else {
                return "-"
        }
        return AppManager.shared.findGenre(withId: genre)
    }
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: URLConfiguration.mediaPath + posterPath)
    }
    
    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: URLConfiguration.mediaBackdropPath + backdropPath)
    }
    
}

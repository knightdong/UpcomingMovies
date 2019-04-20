//
//  UserProvider.swift
//  UpcomingMovies
//
//  Created by Alonso on 3/31/19.
//  Copyright © 2019 Alonso. All rights reserved.
//

import Foundation

enum AccountProvider {
    
    case getAccountDetail(sessionId: String)
    case getFavoriteList(page: Int, sessionId: String, accountId: Int)
    case getWatchlist(page: Int, sessionId: String, accountId: Int)
    case getCustomLists(page: Int, sessionId: String, accountId: Int)
    case getCustomListDetail(id: Int)
    case markAsFavorite(sessionId: String, accountId: Int, movieId: Int, favorite: Bool)
    
}

// MARK: - Endpoint

extension AccountProvider: Endpoint {
    
    var base: String {
        return "https://api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .getAccountDetail:
            return "/3/account"
        case .getFavoriteList( _, _, let accountId):
            return "/3/account/\(accountId)/favorite/movies"
        case .getWatchlist( _, _, let accountId):
            return "/3/account/\(accountId)/watchlist/movies"
        case .getCustomLists( _, _, let accountId):
            return "/3/account/\(accountId)/lists"
        case .getCustomListDetail(let id):
            return "/3/list/\(id)"
        case .markAsFavorite( _, let accountId, _, _):
            return "/3/account/\(accountId)/favorite"
        }
    }
    
    var params: [String: Any]? {
        switch self {
        case .getAccountDetail(let sessionId):
            return ["session_id": sessionId]
        case .getFavoriteList(let page, let sessionId, _):
            return ["session_id": sessionId, "page": page]
        case .getWatchlist(let page, let sessionId, _):
            return ["session_id": sessionId, "page": page]
        case .getCustomLists(let page, let sessionId, _):
            return ["session_id": sessionId, "page": page]
        case .getCustomListDetail:
            return nil
        case .markAsFavorite(let sessionId, _, let movieId, let favorite):
            let queryParams: [String: Any] = ["session_id": sessionId]
            let bodyParams: [String: Any] = ["media_type": "movie",
                                             "media_id": movieId,
                                             "favorite": favorite]
            return ["query": queryParams, "body": bodyParams]
        }
    }
    
    var parameterEncoding: ParameterEnconding {
        switch self {
        case .getAccountDetail, .getFavoriteList, .getWatchlist,
             .getCustomLists, .getCustomListDetail:
            return .defaultEncoding
        case .markAsFavorite:
            return .compositeJSONEncoding
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAccountDetail, .getFavoriteList, .getWatchlist,
             .getCustomLists, .getCustomListDetail:
            return .get
        case .markAsFavorite:
            return .post
        }
    }
    
}

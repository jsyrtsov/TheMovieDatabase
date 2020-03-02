//
//  Constants.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/29/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

enum MoviesManagerLoadingStrategy {
    case popular
    case upcoming
    case nowPlaying
    case search
}

enum urlKeys {
    static let apiKey = "43c76333cdbd2a5869d68050de560ceb"
    static let baseUrl = "https://api.themoviedb.org/3/"
}

//
//  MovieLoadingStrategy.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/3/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

enum MoviesServiceLoadingStrategy {
    case popular
    case upcoming
    case nowPlaying
    case search(query: String?)
}

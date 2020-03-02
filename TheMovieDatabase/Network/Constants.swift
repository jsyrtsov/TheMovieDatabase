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

let apiKey = "43c76333cdbd2a5869d68050de560ceb"
let urlKey = "https://api.themoviedb.org/3/"

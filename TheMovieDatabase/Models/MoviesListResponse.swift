//
//  LoadMoviesResponse.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/25/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

struct MoviesListResponse: Codable {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let results: [Movie]?
}

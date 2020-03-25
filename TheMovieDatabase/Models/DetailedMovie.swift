//
//  DetailedMovie.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/4/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

struct DetailedMovie: Codable {
    let backdropPath: String?
    let overview: String?
    let budget: Int?
    let revenue: Int?
    let title: String?
    let runtime: Int?
    let originalLanguage: String?
    let posterPath: String?
    let id: Int?
    let voteAverage: Double?
    let releaseDate: String?
    let tagline: String?
}

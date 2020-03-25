//
//  Movie.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/25/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let backdropPath: String?
    let posterPath: String?
    let id: Int?
    let title: String?
    let voteAverage: Double?
    let overview: String?
    let releaseDate: String?
}

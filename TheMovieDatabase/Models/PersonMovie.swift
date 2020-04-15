//
//  PersonMovie.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/6/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

struct PersonMovie: Codable {
    let job: String?
    let character: String?
    let releaseDate: String?
    let voteAverage: Double?
    let title: String?
    let posterPath: String?
    let id: Int?
}

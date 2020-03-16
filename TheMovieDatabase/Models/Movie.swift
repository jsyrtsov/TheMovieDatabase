//
//  Movie.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/25/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

struct Movie: Codable {
    //let popularity: Double?
    //let voteCount: Int?
    //let video: Bool
    let posterPath: String?
    let id: Int?
    //let adult: Bool
    //let backdropPath: String?
    //let originalLanguare: String?
    //let originalTitle: String?
    //let genreIds: [Int]?
    let title: String?
    //let voteAverage: Double?
    let overview: String?
    //let releaseDate: String?
}

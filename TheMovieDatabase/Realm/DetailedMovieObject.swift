//
//  DetailedMovieObject.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/13/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import RealmSwift

class DetailedMovieObject: Object {
    let voteAverage = RealmOptional<Double>()
    @objc dynamic var releaseDate: String?
    @objc dynamic var overview: String?
    @objc dynamic var title: String?
    @objc dynamic var originalLanguage: String?
    @objc dynamic var posterPath: String?
    @objc dynamic var backdropPath: String?
    let runtime = RealmOptional<Int>()
    let budget = RealmOptional<Int>()
    let revenue = RealmOptional<Int>()
    let id = RealmOptional<Int>()

    convenience init(title: String?,
                     backdropPath: String?,
                     overview: String?,
                     posterPath: String?,
                     originalLanguage: String?,
                     runtime: Int?,
                     budget: Int?,
                     revenue: Int?,
                     id: Int?,
                     voteAverage: Double?,
                     releaseDate: String?) {
        self.init()
        self.backdropPath = backdropPath
        self.voteAverage.value = voteAverage
        self.releaseDate = releaseDate
        self.overview = overview
        self.title = title
        self.originalLanguage = originalLanguage
        self.posterPath = posterPath
        self.runtime.value = runtime
        self.budget.value = budget
        self.revenue.value = revenue
        self.id.value = id
    }
}

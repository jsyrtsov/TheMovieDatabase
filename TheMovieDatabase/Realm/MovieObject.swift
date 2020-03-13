//
//  MovieObject.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/13/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import RealmSwift

class MovieObject: Object {
    let id = RealmOptional<Int>()
    @objc dynamic var posterPath: String?
    @objc dynamic var title: String?
    @objc dynamic var overview: String?

    convenience init(id: Int?,
                     posterPath: String?,
                     title: String?,
                     overview: String?) {
        self.init()
        self.id.value = id
        self.posterPath = posterPath
        self.title = title
        self.overview = overview
    }
}

//
//  StorageService.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/13/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import RealmSwift

class StorageService {

    private let realm = try? Realm()

    func saveDetailedMovie(movie: DetailedMovieObject) {
        try? realm?.write {
            realm?.add(movie)
        }
    }

    func saveMovie(movie: MovieObject) {
        try? realm?.write {
            realm?.add(movie)
        }
    }
}

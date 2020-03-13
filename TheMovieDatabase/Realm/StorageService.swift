//
//  StorageService.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/13/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import RealmSwift

let realm = try? Realm()

class StorageService {

    func saveDetailedMovie(withMovie movie: DetailedMovieObject) {
        try? realm?.write {
            realm?.add(movie)
        }
    }

    func deleteDetailedMovie(withMovie movie: DetailedMovieObject) {
        try? realm?.write {
            realm?.delete(movie)
        }
    }

    func saveMovie(withMovie movie: MovieObject) {
        try? realm?.write {
            realm?.add(movie)
        }
    }
}

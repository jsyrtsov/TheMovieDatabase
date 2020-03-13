//
//  StorageService.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/13/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import RealmSwift

let realm = try? Realm()

class StorageManager {

    func saveObject(withMovie movie: MovieObject) {
        try? realm?.write {
            realm?.add(movie)
        }
    }

    func deleteObject(withMovie movie: MovieObject) {
        try? realm?.write {
            realm?.delete(movie)
        }
    }
}

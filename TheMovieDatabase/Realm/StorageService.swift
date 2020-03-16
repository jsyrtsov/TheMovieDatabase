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

    func saveObject<T: Object>(object: T?) {
        try? realm?.write {
            guard let object = object else {
                return
            }
            realm?.add(object)
        }
    }

    func ckeckLike<T>(object: T, id: Int?) -> Bool {
        guard let object = object as? Object.Type, let id = id else {
            return false
        }
        guard let filtered = realm?.objects(object.self).filter("id == \(id)") else {
            return false
        }
        if filtered.isEmpty {
            return false
        } else {
            return true
        }
    }

    func removeObjectWithId<T: Object>(object: T.Type, id: Int?) {
        guard let id = id else {
            return
        }
        // swiftlint:disable first_where
        guard let foundObject = realm?.objects(T.self).filter("id == \(id)").first else {
            return
        }
        // swiftlint:enable first_where
        try? realm?.write {
            realm?.delete(foundObject)
        }
    }

    func getFavMovies() -> [Movie] {
        guard let objects = realm?.objects(MovieObject.self) else {
            return []
        }
        var movies: [Movie] = []
        for element in objects {
            let movie = Movie(posterPath: element.posterPath,
                              id: element.id.value,
                              title: element.title,
                              overview: element.overview)
            movies.append(movie)
        }
        return movies
    }
}

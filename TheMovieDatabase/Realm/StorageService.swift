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

    func findObjectWithId<T>(object: T, id: Int) -> Object? {
        guard let object = object as? Object.Type else {
            return nil
        }
        // swiftlint:disable first_where
        let filtered = realm?.objects(object.self).filter("id == \(id)").first
        // swiftlint:enable first_where
        return filtered
    }

    func removeObject<T>(object: T) {
        guard let object = object as? Object else {
            return
        }
        try? realm?.write {
            realm?.delete(object)
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

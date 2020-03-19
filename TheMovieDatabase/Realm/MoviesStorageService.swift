//
//  StorageMoviesService.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/16/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation
import RealmSwift

class MoviesStorageService: StorageService {

    private let realm = try? Realm()

    func getFavoriteMovies() -> [Movie] {
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

    func getMovieInfo(id: Int?) -> DetailedMovie? {
        guard let id = id else {
            return nil
        }
        // swiftlint:disable first_where
        guard let object = realm?.objects(DetailedMovieObject.self).filter("id == \(id)").first else {
            return nil
        }
        // swiftlint:enable first_where
        let movie = DetailedMovie(overview: object.overview,
                                  budget: object.budget.value,
                                  revenue: object.revenue.value,
                                  title: object.title,
                                  runtime: object.runtime.value,
                                  originalLanguage: object.originalLanguage,
                                  posterPath: object.posterPath,
                                  id: object.id.value)
        return movie
    }

    func isListedMovie(id: Int?) -> Bool {
        return isListed(object: MovieObject.self, id: id)
    }

    func saveDetailedMovie(detailedMovie: DetailedMovie?) {
        var detailedMovieObject: DetailedMovieObject?
        detailedMovieObject = DetailedMovieObject(title: detailedMovie?.title,
                                                  overview: detailedMovie?.overview,
                                                  posterPath: detailedMovie?.posterPath,
                                                  originalLanguage: detailedMovie?.originalLanguage,
                                                  runtime: detailedMovie?.runtime,
                                                  budget: detailedMovie?.budget,
                                                  revenue: detailedMovie?.revenue,
                                                  id: detailedMovie?.id)
        saveObject(object: detailedMovieObject)
    }

    func removeMovieWithId(id: Int?) {
        removeObjectWithId(object: MovieObject.self, id: id)
    }

    func removeDetailedMovieWithId(id: Int?) {
        removeObjectWithId(object: DetailedMovieObject.self, id: id)
    }

    func saveMovie(detailedMovie: DetailedMovie?) {
        let movie = Movie(posterPath: detailedMovie?.posterPath,
                          id: detailedMovie?.id,
                          title: detailedMovie?.title,
                          overview: detailedMovie?.overview)

        var movieObject: MovieObject?
        movieObject = MovieObject(id: movie.id,
                                  posterPath: movie.posterPath,
                                  title: movie.title,
                                  overview: movie.overview)
        saveObject(object: movieObject)
    }
}

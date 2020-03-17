//
//  MovieLoadingManager.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/2/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation
import RealmSwift

class MoviesLoadingService {
    private let storageMoviesService = StorageMoviesService()
    private var totalPages: Int = 1
    private var currentPage: Int = 1
    private var query: String?
    var canLoadMore: Bool = false
    var strategy: MoviesServiceLoadingStrategy = .popular

    func loadMovies(completion: @escaping ([Movie]?) -> Void) {
        var url: URL?
        switch strategy {
        case .popular:
            url = URL(string: UrlParts.baseUrl + "movie/popular")
        case .upcoming:
            url = URL(string: UrlParts.baseUrl + "movie/upcoming")
        case .nowPlaying:
            url = URL(string: UrlParts.baseUrl + "movie/now_playing")
        case .search(let query):
            url = URL(string: UrlParts.baseUrl + "search/movie")
            url = url?.appending("query", value: query)
        }

        url = url?.appending("api_key", value: UrlParts.apiKey)
        url = url?.appending("page", value: String(currentPage))

        guard let loadingURL = url else {
            return
        }
        URLSession.shared.dataTask(with: loadingURL) { (data, response, error) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return completion(nil)
            }
            do {
                let result = try decoder.decode(MoviesListResponse.self, from: data)
                DispatchQueue.main.async {
                    guard let totalPages = result.totalPages else {
                        return
                    }
                    self.totalPages = totalPages
                    if self.currentPage < totalPages {
                        self.canLoadMore = true
                    } else {
                        self.canLoadMore = false
                    }
                    self.currentPage += 1
                    completion(result.results)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }

    func loadDetails(withMovieId movieId: Int, completion: @escaping (DetailedMovie?) -> Void) {
        var url: URL?
        url = URL(string: UrlParts.baseUrl + "movie/\(movieId)")
        url = url?.appending("api_key", value: UrlParts.apiKey)
        guard let urlLoading = url else {
            return
        }
        URLSession.shared.dataTask(with: urlLoading) { (data, response, error) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return
                    DispatchQueue.main.async {
                        completion(self.storageMoviesService.getMovieInfo(id: movieId))
                    }
            }
            do {
                let result = try decoder.decode(DetailedMovie.self, from: data)
                DispatchQueue.main.async {
                    completion(result)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(self.storageMoviesService.getMovieInfo(id: movieId))
                }
            }
        }.resume()
    }

    func saveObject<T: Object>(object: T?) {
        storageMoviesService.saveObject(object: object)
    }

    func isFavorite<T>(object: T, id: Int?) -> Bool {
        storageMoviesService.isFavorite(object: object, id: id)
    }

    func removeObjectWithId<T: Object>(object: T.Type, id: Int?) {
        storageMoviesService.removeObjectWithId(object: object, id: id)
    }

    func getFavMovies() -> [Movie] {
        storageMoviesService.getFavoriteMovies()
    }

    func getMovieInfo(id: Int?) -> DetailedMovie? {
        storageMoviesService.getMovieInfo(id: id)
    }
}

private struct MoviesListResponse: Codable {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let results: [Movie]?
}

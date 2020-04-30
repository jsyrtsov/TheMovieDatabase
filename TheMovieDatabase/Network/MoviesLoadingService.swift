//
//  MoviesLoadingService.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/2/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

final class MoviesLoadingService {

    // MARK: - Properties

    private let storageMoviesService = MoviesStorageService()
    private var totalPages: Int = 1
    private var currentPage: Int = 1
    private var query: String?
    var canLoadMore: Bool = false
    var strategy: MoviesServiceLoadingStrategy = .popular {
        didSet {
            currentPage = 1
        }
    }

    // MARK: - Methods

    func loadMovies(completion: @escaping ([Movie]?) -> Void) {
        var baseUrl: URL?
        switch strategy {
        case .popular:
            baseUrl = URL(string: UrlParts.baseUrl + "movie/popular")
        case .upcoming:
            baseUrl = URL(string: UrlParts.baseUrl + "movie/upcoming")
        case .nowPlaying:
            baseUrl = URL(string: UrlParts.baseUrl + "movie/now_playing")
        case .search(let query):
            baseUrl = URL(string: UrlParts.baseUrl + "search/movie")?
                .appending("query", value: query)
        }

        guard
            let url = baseUrl?.appending("api_key", value: UrlParts.apiKey)?
                .appending("page", value: String(currentPage))
        else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
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

    func loadFavoriteMovies(accountId: Int, completion: @escaping ([Movie]?) -> Void) {
        if AuthorizationService.getSessionId() != nil {
            let movies = self.getFavoriteMovies()
            for movie in movies {
                self.removeMovie(id: movie.id)
            }
            guard
                let url = URL(string: UrlParts.baseUrl + "account/\(accountId)/favorite/movies")?
                    .appending("api_key", value: UrlParts.apiKey)?
                    .appending("session_id", value: AuthorizationService.getSessionId())?
                    .appending("page", value: String(currentPage))
            else {
                return
            }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    return
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let result = try decoder.decode(MoviesListResponse.self, from: data)
                    DispatchQueue.main.async {
                        guard
                            let totalPages = result.totalPages,
                            let movies = result.results
                        else {
                            return
                        }
                        self.totalPages = totalPages
                        if self.currentPage < totalPages {
                            self.canLoadMore = true
                        } else {
                            self.canLoadMore = false
                        }
                        self.currentPage += 1
                        for movie in movies {
                            self.storageMoviesService.saveMovie(movie: movie)
                        }
                        completion(movies)
                    }
                } catch {
                    completion(nil)
                }
            }.resume()
        } else {
            completion(storageMoviesService.getFavoriteMovies())
        }
    }

    func loadDetails(movieId: Int, completion: @escaping (DetailedMovie?) -> Void) {
        guard
            let url = URL(string: UrlParts.baseUrl + "movie/\(movieId)")?
                .appending("api_key", value: UrlParts.apiKey)
        else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return DispatchQueue.main.async {
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

    func loadCastAndCrew(movieId: Int, completion: @escaping ([CastEntry]?, [CrewEntry]?) -> Void) {
        guard
            let url = URL(string: UrlParts.baseUrl + "movie/\(movieId)/credits")?
                .appending("api_key", value: UrlParts.apiKey)
        else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return
            }
            do {
                let result = try decoder.decode(CreditsResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.cast, result.crew)
                }
            } catch {
                completion(nil, nil)
            }
        }.resume()
    }

    func loadVideos(movieId: Int, completion: @escaping ([Video]?) -> Void) {
        guard
            let url = URL(string: UrlParts.baseUrl + "movie/\(movieId)/videos")?
                .appending("api_key", value: UrlParts.apiKey)
        else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return
            }
            do {
                let result = try decoder.decode(VideosResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.results)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }

    func saveMovie(movie: Movie?) {
        storageMoviesService.saveMovie(movie: movie)
    }

    func saveDetailedMovie(detailedMovie: DetailedMovie?) {
        storageMoviesService.saveDetailedMovie(detailedMovie: detailedMovie)
    }

    func isListedMovie(id: Int?) -> Bool {
        return storageMoviesService.isListedMovie(id: id)
    }

    func removeMovie(id: Int?) {
        storageMoviesService.removeMovieWithId(id: id)
    }

    func removeDetailedMovie(id: Int?) {
        storageMoviesService.removeDetailedMovieWithId(id: id)
    }

    func getFavoriteMovies() -> [Movie] {
        storageMoviesService.getFavoriteMovies()
    }

    func getMovieInfo(id: Int?) -> DetailedMovie? {
        storageMoviesService.getMovieInfo(id: id)
    }
}

// MARK: - Private Structs

private struct VideosResponse: Codable {
    let id: Int?
    let results: [Video]?
}

private struct CreditsResponse: Codable {
    let id: Int?
    let cast: [CastEntry]?
    let crew: [CrewEntry]?
}

private struct MoviesListResponse: Codable {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let results: [Movie]?
}

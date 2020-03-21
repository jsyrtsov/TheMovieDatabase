//
//  MovieLoadingManager.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/2/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

class MoviesLoadingService {
    private let decoder = JSONDecoder()
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

        guard let urlNotNil = url else {
            return
        }
        URLSession.shared.dataTask(with: urlNotNil) { (data, response, error) in
            self.decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return completion(nil)
            }
            do {
                let result = try self.decoder.decode(MoviesListResponse.self, from: data)
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

    func loadDetails(movieId: Int, completion: @escaping (DetailedMovie?) -> Void) {
        var url: URL?
        url = URL(string: UrlParts.baseUrl + "movie/\(movieId)")
        url = url?.appending("api_key", value: UrlParts.apiKey)
        guard let urlNotNil = url else {
            return
        }
        URLSession.shared.dataTask(with: urlNotNil) { (data, response, error) in
            self.decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return
                    DispatchQueue.main.async {
                        completion(self.storageMoviesService.getMovieInfo(id: movieId))
                    }
            }
            do {
                let result = try self.decoder.decode(DetailedMovie.self, from: data)
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

    func loadCastAndCrew(movieId: Int, completion: @escaping (CreditsResponse?) -> Void) {
        var url: URL?
        url = URL(string: UrlParts.baseUrl + "movie/\(movieId)/credits")
        url = url?.appending("api_key", value: UrlParts.apiKey)
        guard let urlNotNil = url else {
            return
        }
        print(urlNotNil.absoluteString)
        URLSession.shared.dataTask(with: urlNotNil) { (data, response, error) in
            self.decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return
            }
            do {
                let result = try self.decoder.decode(CreditsResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result)
                }
            } catch {
                print(error)
            }
        }.resume()
    }

    func saveMovie(detailedMovie: DetailedMovie?) {
        storageMoviesService.saveMovie(detailedMovie: detailedMovie)
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

struct CreditsResponse: Codable {
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

//
//  MoviesService.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/2/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

final class MoviesService {

    // MARK: - Properties

    private let storageMoviesService = MoviesStorageService()
    private var totalPages: Int = 1
    private var currentPage: Int = 1
    private var query: String?
    var canLoadMore: Bool = false
    var strategy: MoviesServiceStrategy = .popular {
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
        guard AuthorizationService.sessionId != nil else {
            completion(storageMoviesService.getFavoriteMovies())
            return
        }
        let movies = self.getFavoriteMovies()
        for movie in movies {
            self.removeMovie(id: movie.id)
        }
        guard
            let url = URL(string: UrlParts.baseUrl + "account/\(accountId)/favorite/movies")?
                .appending("api_key", value: UrlParts.apiKey)?
                .appending("session_id", value: AuthorizationService.sessionId)?
                .appending("page", value: String(currentPage))
        else {
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard
                let self = self,
                let data = data
            else {
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
                        self.storageMoviesService.save(movie: movie)
                    }
                    completion(movies)
                }
            } catch {
                completion(nil)
            }
        }.resume()
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

    func setFavoriteTo(_ isFavorite: Bool,
                       movie: Movie?,
                       detailedMovie: DetailedMovie?,
                       completion: @escaping (Result<[Movie]?, Error>) -> Void) {
        guard let movieId = movie?.id else {
            return
        }
        if AuthorizationService.sessionId != nil {
            let userData = [
                "media_type": "movie",
                "media_id": movieId,
                "favorite": isFavorite
            ] as [String: Any]
            guard
                let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []),
                let url = URL(string: UrlParts.baseUrl + "account/\(UserDefaults.standard.accountId)/favorite")?
                    .appending("api_key", value: UrlParts.apiKey)?
                    .appending("session_id", value: AuthorizationService.sessionId)
            else {
                return completion(.failure(NetworkError.invalidHttpBodyData))
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = httpBody
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let data = data else {
                    return completion(.failure(NetworkError.noDataProvided))
                }
                do {
                    let result = try decoder.decode(StatusResponse.self, from: data)
                    DispatchQueue.main.async {
                        guard
                            let statusCode = result.statusCode,
                            let statusMessage = result.statusMessage
                        else {
                            return
                        }
                        if statusCode == 1 || statusCode == 13 {
                            if isFavorite {
                                self.save(movie: movie)
                                self.save(detailedMovie: detailedMovie)
                            } else {
                                self.removeMovie(id: movieId)
                                self.removeDetailedMovie(id: movieId)
                            }
                            let movies = self.getFavoriteMovies()
                            completion(.success(movies))
                        } else {
                            let userInfo: [String: Any] = [NSLocalizedDescriptionKey: statusMessage]
                            let error = NSError(domain: "", code: statusCode, userInfo: userInfo)
                            completion(.failure(error))
                            print(error.localizedDescription)
                        }
                    }
                } catch {
                    completion(.failure(NetworkError.failedToDecode))
                }
            }.resume()
        } else {
            if isFavorite {
                self.save(movie: movie)
                self.save(detailedMovie: detailedMovie)
            } else {
                self.removeMovie(id: movieId)
                self.removeDetailedMovie(id: movieId)
            }
            let movies = self.getFavoriteMovies()
            completion(.success(movies))
        }
    }

    func save(movie: Movie?) {
        storageMoviesService.save(movie: movie)
    }

    func save(detailedMovie: DetailedMovie?) {
        storageMoviesService.save(detailedMovie: detailedMovie)
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

// MARK: - Structs

struct StatusResponse: Codable {
    let statusCode: Int?
    let statusMessage: String?
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

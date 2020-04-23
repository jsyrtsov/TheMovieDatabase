//
//  ProfileService.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/17/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

final class ProfileService {

    // MARK: - Properties

    private let moviesLoadingService = MoviesLoadingService()
    private let guestAccount = Account(id: nil,
                                       name: "Guest",
                                       username: "Guest",
                                       includeAdult: true)

    // MARK: - Methods

    func getAccountDetails(completion: @escaping (Result<Account?, Error>) -> Void) {
        if AuthorizationService.getSessionId() != nil {
            guard
                let sessionId = AuthorizationService.getSessionId(),
                let url = URL(string: UrlParts.baseUrl + "account")?
                    .appending("api_key", value: UrlParts.apiKey)?
                    .appending("session_id", value: sessionId)
            else {
                return
            }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
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
                    let result = try decoder.decode(Account.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                } catch {
                    completion(.failure(NetworkError.failedToDecode))
                }
            }.resume()
        } else {
            completion(.success(guestAccount))
        }
    }

    func setFavoriteTo(_ isFavorite: Bool,
                       movie: Movie?,
                       detailedMovie: DetailedMovie?,
                       completion: @escaping (Result<[Movie]?, Error>) -> Void) {
        guard let movieId = movie?.id else {
            return
        }
        if AuthorizationService.getSessionId() != nil {
            let userData = [
                "media_type": "movie",
                "media_id": movieId,
                "favorite": isFavorite
            ] as [String: Any]
            guard
                let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []),
                let url = URL(string: UrlParts.baseUrl + "account/\(UserDefaults.standard.accountId)/favorite")?
                    .appending("api_key", value: UrlParts.apiKey)?
                    .appending("session_id", value: AuthorizationService.getSessionId())
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
                    let result = try decoder.decode(SetFavoriteResponse.self, from: data)
                    DispatchQueue.main.async {
                        guard let statusCode = result.statusCode else {
                            return
                        }
                        if statusCode == 1 || statusCode == 13 {
                            if isFavorite {
                                self.moviesLoadingService.saveMovie(movie: movie)
                                self.moviesLoadingService.saveDetailedMovie(detailedMovie: detailedMovie)
                            } else {
                                self.moviesLoadingService.removeMovie(id: movieId)
                                self.moviesLoadingService.removeDetailedMovie(id: movieId)
                            }
                            let movies = self.moviesLoadingService.getFavoriteMovies()
                            completion(.success(movies))
                        }
                    }
                } catch {
                    completion(.failure(NetworkError.failedToDecode))
                }
            }.resume()
        } else {
            if isFavorite {
                self.moviesLoadingService.saveMovie(movie: movie)
                self.moviesLoadingService.saveDetailedMovie(detailedMovie: detailedMovie)
            } else {
                self.moviesLoadingService.removeMovie(id: movieId)
                self.moviesLoadingService.removeDetailedMovie(id: movieId)
            }
            let movies = self.moviesLoadingService.getFavoriteMovies()
            completion(.success(movies))
        }
    }
}

// MARK: - Private Structs

private struct SetFavoriteResponse: Codable {
    let statusCode: Int?
    let statusMessage: String?
}

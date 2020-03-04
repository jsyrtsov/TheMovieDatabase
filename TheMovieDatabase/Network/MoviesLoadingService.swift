//
//  MovieLoadingManager.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/2/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

class MoviesLoadingService {
    private var totalPages: Int = 1
    private var currentPage: Int = 1
    private var strategy: MoviesServiceLoadingStrategy
    private var query: String?
    var canLoadMore: Bool = false
    init(strategy: MoviesServiceLoadingStrategy) {
        self.strategy = strategy
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

        guard let loadingURL = url else {
            return
        }
        URLSession.shared.dataTask(with: loadingURL) { (data, response, error) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return
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
}

private struct MoviesListResponse: Codable {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let results: [Movie]?
}

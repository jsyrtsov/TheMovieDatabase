//
//  MovieLoadingManager.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/2/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

class MovieLoadingManager {
    private var totalPages: Int = 1
    private var currentPage: Int = 1
    private var strategy: MoviesManagerLoadingStrategy
    private var query: String?
    var canLoadMore: Bool = false
    init(strategy: MoviesManagerLoadingStrategy, query: String?) {
        self.strategy = strategy
        self.query = query
    }

    func loadMovies(completion: @escaping ([Movie]?) -> Void) {
        var url: URL?
        switch strategy {
        case .popular:
            url = URL(string: urlKeys.baseUrl + "movie/popular")
        case .upcoming:
            url = URL(string: urlKeys.baseUrl + "movie/upcoming")
        case .nowPlaying:
            url = URL(string: urlKeys.baseUrl + "movie/now_playing")
        case .search:
            url = URL(string: urlKeys.baseUrl + "search/movie")
            url = url?.appending("query", value: query)
        }

        url = url?.appending("api_key", value: urlKeys.apiKey)
        url = url?.appending("page", value: String(currentPage))

        guard let loadingURL = url else {
            return
        }
        print(loadingURL.absoluteString)
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

struct MoviesListResponse: Codable {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let results: [Movie]?
}

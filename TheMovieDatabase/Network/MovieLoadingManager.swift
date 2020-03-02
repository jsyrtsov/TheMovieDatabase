//
//  MovieLoadingManager.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/2/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

extension URL {
    func appending(_ queryItem: String, value: String?) -> URL? {
        guard var urlComponents = URLComponents(string: absoluteString) else {
            return absoluteURL
        }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        return urlComponents.url
    }
}

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
            url = URL(string: urlKey + "movie/popular")
        case .upcoming:
            url = URL(string: urlKey + "movie/upcoming")
        case .nowPlaying:
            url = URL(string: urlKey + "movie/now_playing")
        case .search:
            url = URL(string: urlKey + "search/movie")
            url = url?.appending("query", value: query)
        }

        url = url?.appending("api_key", value: apiKey)
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

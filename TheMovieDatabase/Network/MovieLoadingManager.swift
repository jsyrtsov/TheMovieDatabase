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

    func loadMovies(completion: @escaping (MoviesListResponse?) -> Void) {
        var urlString: String = ""
        switch strategy {
        case .popular:
            urlString = urlKey + "movie/popular"
        case .upcoming:
            urlString = urlKey + "movie/upcoming"
        case .nowPlaying:
            urlString = urlKey + "movie/now_playing"
        case .search:
            if let query = query {
                urlString = urlKey + "search/movie?query=\(query)"
            }
            urlString = urlKey + "search/movie?query="
        }
        urlString += "?api_key=\(apiKey)&page=\(currentPage)"
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
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
                    }
                    self.currentPage += 1
                    completion(result)
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

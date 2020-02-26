//
//  NetworkService.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/25/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation
import UIKit

class MoviesService {
    private let apiKey = "43c76333cdbd2a5869d68050de560ceb"
    private var currentPageNum = 0

    func loadMovies(completion: @escaping ([Movie]?) -> Void) {
        currentPageNum += 1
        let urlString = """
        https://api.themoviedb.org/3/movie/popular?api_key=\(
        apiKey
        )&language=en-US&page=\(
        currentPageNum
        )
        """
        guard let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let data = data {
                do {
                    let result = try decoder.decode(MoviesListResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(result.results)
                    }
                } catch {
                    completion(nil)
                }
            }
            completion(nil)
        }.resume()
    }
}

private struct MoviesListResponse: Codable {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let results: [Movie]?
}

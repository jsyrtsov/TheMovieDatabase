//
//  NetworkService.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/25/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation
import UIKit

class MoviesManager {
    private let apiKey = "43c76333cdbd2a5869d68050de560ceb"
    var currentPageNum = 1
    var totalPages = 1

    func loadMovies(completion: @escaping ([Movie]?) -> Void) {
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
                        guard let totalPages = result.totalPages, let page = result.page else {
                            return
                        }
                        self.totalPages = totalPages
                        if page < totalPages {
                            self.currentPageNum += 1
                        }
                    }
                } catch {
                    completion(nil)
                }
            }
            completion(nil)
        }.resume()
    }
}

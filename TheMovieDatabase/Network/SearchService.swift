//
//  SearchService.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/27/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation
import UIKit

class SearchService {
    private let apiKey = "43c76333cdbd2a5869d68050de560ceb"
    var currentPageNum = 1

    func loadMovies(withSearchWords searchWords: String, completion: @escaping ([Movie]?) -> Void) {
        let urlString = """
        https://api.themoviedb.org/3/search/movie?api_key=\(
        apiKey
        )&language=en-US&page=\(
        currentPageNum
        )&query=\(
        searchWords
        )
        """
        print(urlString)
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

//
//  DetailedMovieLoadingService.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/4/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

class DetailedMovieLoadingService {
    func loadDetails(withMovieId movieId: Int, completion: @escaping (DetailedMovie?) -> Void) {
        var url: URL?
        url = URL(string: UrlParts.baseUrl + "movie/\(movieId)")
        url = url?.appending("api_key", value: UrlParts.apiKey)
        guard let urlLoading = url else {
            return
        }
        URLSession.shared.dataTask(with: urlLoading) { (data, response, error) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return completion(nil)
            }
            do {
                let result = try decoder.decode(DetailedMovie.self, from: data)
                DispatchQueue.main.async {
                    completion(result)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
}

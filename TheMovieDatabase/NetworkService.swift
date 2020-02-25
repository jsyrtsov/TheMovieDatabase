//
//  NetworkService.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/25/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

class NetworkService {

    func loadMovies(withUrl url: String, completion: @escaping (LoadMoviesResponse) -> Void) {

        guard let url = URL(string: url) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let data = data {
                do {
                    let result = try decoder.decode(LoadMoviesResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(result)
                        print(result)
                    }
                } catch {
                    print(error)
                }

            }
        }.resume()
    }
}

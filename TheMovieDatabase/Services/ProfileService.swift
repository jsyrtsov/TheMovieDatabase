//
//  ProfileService.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/17/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation
import Locksmith

final class ProfileService {

    // MARK: - Methods

    func getAccountDetails(completion: @escaping (Account?) -> Void) {
        guard
            let sessionId = Locksmith.getSessionId(),
            let url = URL(string: UrlParts.baseUrl + "account")?
                .appending("api_key", value: UrlParts.apiKey)?
                .appending("session_id", value: sessionId)
        else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return
            }
            do {
                let result = try decoder.decode(Account.self, from: data)
                DispatchQueue.main.async {
                    completion(result)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }

    func setFavoriteTo(_ isFavorite: Bool, movieId: Int, completion: @escaping (Bool) -> Void) {
        let userData = [
            "media_type": "movie",
            "media_id": movieId,
            "favorite": isFavorite
        ] as [String: Any]
        guard
            let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []),
            let url = URL(string: UrlParts.baseUrl + "account/\(UserDefaults.standard.accountId)/favorite")?
                .appending("api_key", value: UrlParts.apiKey)?
                .appending("session_id", value: Locksmith.getSessionId())
        else {
            return completion(false)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = httpBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return completion(false)
            }
            do {
                let result = try decoder.decode(SetFavoriteResponse.self, from: data)
                DispatchQueue.main.async {
                    guard let statusCode = result.statusCode else {
                        return
                    }
                    if statusCode == 1 || statusCode == 13 {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            } catch {
                completion(false)
            }
        }.resume()
    }
}

// MARK: - Private Structs

private struct SetFavoriteResponse: Codable {
    let statusCode: Int?
    let statusMessage: String?
}

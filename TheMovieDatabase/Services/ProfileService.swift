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

    // MARK: - Properties

    private let appDelegate = UIApplication.shared.delegate as? AppDelegate

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
}

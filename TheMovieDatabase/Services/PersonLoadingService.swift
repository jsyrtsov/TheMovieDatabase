//
//  PersonLoadingService.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/4/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

class PersonLoadingService {

    func loadPerson(personId: Int, completion: @escaping (Person?) -> Void) {
        guard
            let url = URL(string: UrlParts.baseUrl + "person/\(personId)")?
                .appending("api_key", value: UrlParts.apiKey)
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
                let result = try decoder.decode(Person.self, from: data)
                DispatchQueue.main.async {
                    completion(result)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }

    func loadPersonImages(personId: Int, completion: @escaping ([PersonImage]?) -> Void) {
        guard
            let url = URL(string: UrlParts.baseUrl + "person/\(personId)/images")?
                .appending("api_key", value: UrlParts.apiKey)
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
                let result = try decoder.decode(PersonImagesResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.profiles)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
}

private struct PersonImagesResponse: Codable {
    let profiles: [PersonImage]?
    let id: Int?
}
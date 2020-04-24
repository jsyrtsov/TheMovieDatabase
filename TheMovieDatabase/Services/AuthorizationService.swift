//
//  AuthorizationService.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/17/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation
import Locksmith

final class AuthorizationService {

    // MARK: - Properties

    private let profileService = ProfileService()

    // MARK: - Methods

    static func getSessionId() -> String? {
        return Locksmith.sessionId
    }

    func login(login: String,
               password: String,
               completion: @escaping (Result<Void, Error>) -> Void) {
        getToken { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let token):
                guard let token = token else {
                    return
                }
                self.validateToken(token: token, login: login, password: password) { [weak self] (result) in
                    guard let self = self else {
                        return
                    }
                    switch result {
                    case .success(let token):
                        guard let token = token else {
                            return
                        }
                        self.getSessionId(token: token) { [weak self] (result) in
                                guard let self = self else {
                                    return
                                }
                                switch result {
                                case .success(let sessionId):
                                    guard let sessionId = sessionId else {
                                        return
                                    }
                                    Locksmith.save(sessionId: sessionId)
                                    self.profileService.getAccountDetails { (result) in
                                    switch result {
                                        case .success(let account):
                                            guard
                                                let accountId = account?.id,
                                                let username = account?.username
                                            else {
                                                return
                                            }
                                            UserDefaults.standard.accountId = accountId
                                            UserDefaults.standard.username = username
                                            completion(.success(()))
                                        case .failure(let error):
                                            completion(.failure(error))
                                        }
                                    }
                                case .failure(let error):
                                    completion(.failure(error))
                                    Locksmith.deleteUserAccount()
                                }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        guard
            let url = URL(string: UrlParts.baseUrl + "authentication/session")?
                .appending("api_key", value: UrlParts.apiKey),
            let sessionId = AuthorizationService.getSessionId()
        else {
            return completion(.failure(NetworkError.invalidSessionId))
        }
        let userData = ["session_id": sessionId]
        guard
            let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: [])
        else {
            return completion(.failure(NetworkError.invalidHttpBodyData))
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.httpBody = httpBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return completion(.failure(NetworkError.noDataProvided))
            }
            do {
                let result = try decoder.decode(GetSessionIdResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(()))
                    if result.success {
                        Locksmith.deleteUserAccount()
                        UserDefaults.standard.username = "Guest"
                        UserDefaults.standard.accountId = 0
                    }
                }
            } catch {
                completion(.failure(NetworkError.failedToDecode))
            }
        }.resume()
    }

    // MARK: - Private methods

    private func getToken(completion: @escaping (Result<String?, Error>) -> Void) {
        guard
            let url = URL(string: UrlParts.baseUrl + "authentication/token/new")?
                .appending("api_key", value: UrlParts.apiKey)
        else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return completion(.failure(NetworkError.noDataProvided))
            }
            do {
                let result = try decoder.decode(GetTokenResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result.requestToken))
                }
            } catch {
                completion(.failure(NetworkError.failedToDecode))
            }
        }.resume()
    }

    private func validateToken(token: String,
                              login: String,
                              password: String,
                              completion: @escaping (Result<String?, Error>) -> Void) {
        let userData = [
            "username": login,
            "password": password,
            "request_token": token
        ]
        guard
            let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []),
            let url = URL(string: UrlParts.baseUrl + "authentication/token/validate_with_login")?
                .appending("api_key", value: UrlParts.apiKey)
        else {
            return completion(.failure(NetworkError.invalidHttpBodyData))
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = httpBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return completion(.failure(NetworkError.noDataProvided))
            }
            if let result = try? decoder.decode(ValidateTokenSuccessResponse.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(result.requestToken))
                }
            } else if let result = try? decoder.decode(ValidateTokenFailureResponse.self, from: data) {
                let userInfo: [String: Any] = [NSLocalizedDescriptionKey: result.statusMessage]
                let error = NSError(domain: "", code: result.statusCode, userInfo: userInfo)
                completion(.failure(error))
            } else {
                completion(.failure(NetworkError.failedToDecode))
            }
        }.resume()
    }

    private func getSessionId(token: String, completion: @escaping (Result<String?, Error>) -> Void) {
        let userData = ["request_token": token]
        guard
            let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []),
            let url = URL(string: UrlParts.baseUrl + "authentication/session/new")?
                .appending("api_key", value: UrlParts.apiKey)
        else {
            return completion(.failure(NetworkError.invalidHttpBodyData))
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = httpBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return completion(.failure(NetworkError.noDataProvided))
            }
            do {
                let result = try decoder.decode(GetSessionIdResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result.sessionId))
                }
            } catch {
                completion(.failure(NetworkError.failedToDecode))
            }
        }.resume()
    }
}

// MARK: - Private Structs

private struct GetTokenResponse: Codable {
    let success: Bool
    let expiresAt: String?
    let requestToken: String?
}

private struct ValidateTokenSuccessResponse: Codable {
    let success: Bool
    let expiresAt: String?
    let requestToken: String?
}

private struct ValidateTokenFailureResponse: Codable {
    let statusMessage: String
    let statusCode: Int
}

private struct GetSessionIdResponse: Codable {
    let success: Bool
    let sessionId: String?
}

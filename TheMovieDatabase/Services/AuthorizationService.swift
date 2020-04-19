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

    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private let profileService = ProfileService()

    // MARK: - Methods

    func getSessionId() -> String? {
        return Locksmith.getSessionId()
    }

    func login(login: String, password: String) {
        getToken { [weak self] (token) in
            guard
                let self = self,
                let token = token
            else {
                return
            }
            self.validateToken(token: token, login: login, password: password) { [weak self] (success, token) in
                guard
                    let self = self,
                    let token = token
                else {
                    return
                }
                self.getSessionId(token: token) { [weak self] (success, sessionId) in
                    guard
                        let self = self,
                        let sessionId = sessionId
                    else {
                        return
                    }
                    Locksmith.save(sessionId: sessionId)
                    if success {
                        self.profileService.getAccountDetails { (account) in
                            guard
                                let accountId = account?.id,
                                let username = account?.username
                            else {
                                return
                            }
                            UserDefaults.standard.accountId = accountId
                            UserDefaults.standard.username = username
                            self.appDelegate?.initializeRootView()
                        }
                        UserDefaults.standard.loginViewWasShown = true
                    } else {
                        Locksmith.deleteUserAccount()
                    }
                }
            }
        }
    }

    func logout(completion: @escaping (Bool) -> Void) {
        guard
            let url = URL(string: UrlParts.baseUrl + "authentication/session")?
                .appending("api_key", value: UrlParts.apiKey),
            let sessionId = self.getSessionId()
        else {
            return
        }
        let userData = ["session_id": sessionId]
        guard
            let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: [])
        else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.httpBody = httpBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return
            }
            do {
                let result = try decoder.decode(GetSessionIdResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.success)
                    UserDefaults.standard.loginViewWasShown = false
                    if result.success {
                        Locksmith.deleteUserAccount()
                        UserDefaults.standard.username = "Guest"
                        UserDefaults.standard.accountId = 0
                    }
                }
            } catch {
                completion(false)
            }
        }.resume()
    }

    // MARK: - Private methods

    private func getToken(completion: @escaping (String?) -> Void) {
        guard
            let url = URL(string: UrlParts.baseUrl + "authentication/token/new")?
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
                let result = try decoder.decode(GetTokenResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.requestToken)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }

    private func validateToken(token: String,
                              login: String,
                              password: String,
                              completion: @escaping (Bool, String?) -> Void) {
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
            return
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
                return
            }
            do {
                let result = try decoder.decode(ValidateTokenResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.success, result.requestToken)
                }
            } catch {
                completion(false, nil)
            }
        }.resume()
    }

    private func getSessionId(token: String, completion: @escaping (Bool, String?) -> Void) {
        let userData = ["request_token": token]
        guard
            let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []),
            let url = URL(string: UrlParts.baseUrl + "authentication/session/new")?
                .appending("api_key", value: UrlParts.apiKey)
        else {
            return
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
                return
            }
            do {
                let result = try decoder.decode(GetSessionIdResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.success, result.sessionId)
                }
            } catch {
                completion(false, nil)
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

private struct ValidateTokenResponse: Codable {
    let success: Bool
    let expiresAt: String?
    let requestToken: String?
}

private struct GetSessionIdResponse: Codable {
    let success: Bool
    let sessionId: String?
}

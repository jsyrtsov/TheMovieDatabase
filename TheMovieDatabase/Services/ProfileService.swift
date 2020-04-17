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

    func authorizeUser(login: String, password: String) {
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
                    do {
                        try Locksmith.updateData(data: ["sessionId": sessionId], forUserAccount: "loggedUserAccout")
                    } catch {
                        //OBRABOTKA OSHIBKI
                        print("unable to save")
                    }
                    if success {
                        self.appDelegate?.initializeRootView()
                        UserDefaults.standard.isLogged = true
                    } else {
                        UserDefaults.standard.isLogged = false
                    }
                }
            }
        }
    }

    func getAccountDetails(completion: @escaping (Account?) -> Void) {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: "loggedUserAccout")
        guard
            let sessionId = dictionary?["sessionId"] as? String,
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
                UserDefaults.standard.isLogged = false
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
                UserDefaults.standard.isLogged = false
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
                UserDefaults.standard.isLogged = false
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

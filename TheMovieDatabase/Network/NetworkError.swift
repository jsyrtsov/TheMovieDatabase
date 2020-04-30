//
//  NetworkError.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/23/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError {
    case noDataProvided
    case failedToDecode
    case invalidHttpBodyData
    case invalidSessionId
    case keychainReadError

    var errorDescription: String? {
        switch self {
        case .noDataProvided:
            return "No data was provided by server"
        case .failedToDecode:
            return "Failed to decode JSON from server"
        case .invalidHttpBodyData:
            return "There is invalid data for HTTP body"
        case .invalidSessionId:
            return "There is invalid session id. Try to re-login"
        case .keychainReadError:
            return "There is keychain reading error"
        }
    }
}

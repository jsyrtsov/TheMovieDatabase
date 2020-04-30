//
//  Account.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/17/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

struct Account: Codable {
    let id: Int?
    let name: String?
    let username: String?
    let includeAdult: Bool
}

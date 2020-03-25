//
//  Video.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/23/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

struct Video: Codable {
    let id: String?
    let key: String?
    let name: String?
    let type: String?
    let size: Int?
    let site: String?
}

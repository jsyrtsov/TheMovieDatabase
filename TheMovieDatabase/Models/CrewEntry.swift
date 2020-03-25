//
//  CrewEntry.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

struct CrewEntry: Codable {
    let creditId: String?
    let department: String?
    let gender: Int?
    let id: Int?
    let job: String?
    let name: String?
    let profilePath: String?
}

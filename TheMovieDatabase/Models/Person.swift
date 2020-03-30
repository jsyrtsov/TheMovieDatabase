//
//  Person.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/30/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

struct Person: Codable {
    let birthday: String?
    let knownForDepartment: String?
    let deathday: String?
    let id: Int?
    let name: String?
    let gender: Int?
    let biography: String?
    let placeOfBirth: String?
    let profilePath: String?
}

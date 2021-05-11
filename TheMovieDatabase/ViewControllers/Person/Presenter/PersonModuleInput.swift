//
//  PersonModuleInput.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/5/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

protocol PersonModuleInput: AnyObject {
    func configure(personId: Int?)
}

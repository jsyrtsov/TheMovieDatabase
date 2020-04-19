//
//  UserDefaults.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/17/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

extension UserDefaults {
    var loginViewWasShown: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }

    var accountId: Int {
        get { return integer(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }

    var username: String {
        get { return string(forKey: #function) ?? "Guest" }
        set { set(newValue, forKey: #function) }
    }
}

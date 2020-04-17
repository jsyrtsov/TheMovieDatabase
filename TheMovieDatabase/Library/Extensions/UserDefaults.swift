//
//  UserDefaults.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/17/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

extension UserDefaults {
    var isLogged: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }

    var wantAsGuest: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }

    var loginViewWasShown: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
}

//
//  Locksmith.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/18/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation
import Locksmith

extension Locksmith {
    static let loggedUserAccount = "loggedUserAccout"
    static func getSessionId() -> String? {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: Locksmith.loggedUserAccount)
        guard
            let sessionId = dictionary?["sessionId"] as? String
        else {
            return nil
        }
        return sessionId
    }

    static func save(sessionId: String) {
        do {
            try Locksmith.updateData(data: ["sessionId": sessionId], forUserAccount: Locksmith.loggedUserAccount)
        } catch {
            print("unable to save")
        }
    }

    static func deleteUserAccount() {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: Locksmith.loggedUserAccount)
        } catch {
            print("unable to delete")
        }
    }
}

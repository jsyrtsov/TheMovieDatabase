//
//  UIColor.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/24/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func color(forVote: Double) -> UIColor {
        if forVote >= 7.5 {
            return UIColor(red: 30 / 255,
                           green: 134 / 255,
                           blue: 53 / 255,
                           alpha: 1)
        } else if forVote < 6.0 && forVote > 0.0 {
            return UIColor(red: 155 / 255,
                           green: 36 / 255,
                           blue: 36 / 255,
                           alpha: 1)
        } else {
            return UIColor(red: 124 / 255,
                           green: 124 / 255,
                           blue: 124 / 255,
                           alpha: 1)
        }
    }
}

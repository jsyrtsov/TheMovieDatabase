//
//  UIView.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func applyShadow(radius: CGFloat, opacity: Float, offsetW: Int, offsetH: Int) {
        let color: UIColor = .black
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: offsetW, height: offsetH)
        self.layer.masksToBounds = false
    }
}

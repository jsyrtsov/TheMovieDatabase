//
//  ImageInCell.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/26/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation
import UIKit
import Nuke

extension UIImageView {
    func loadPoster(withPosterPath posterPath: String?) {
        let blankImageUrl = "https://image.tmdb.org/t/p/w500"
        if let imageUrlString = posterPath,
            let imageUrl = URL(string: blankImageUrl + imageUrlString) {
            Nuke.loadImage(with: imageUrl, into: self)
        }
    }
}

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
    func loadPicture(posterPath: String?) {
        let blankImageUrl = "https://image.tmdb.org/t/p/w500"
        if let pathNotNil = posterPath,
            let imageUrl = URL(string: blankImageUrl + pathNotNil) {
            Nuke.loadImage(with: imageUrl, into: self)
        }
    }

    func loadFullPicture(path: String?) {
        let blankImageUrl = "https://image.tmdb.org/t/p/original"
        if let pathNotNil = path,
            let imageUrl = URL(string: blankImageUrl + pathNotNil) {
            Nuke.loadImage(with: imageUrl, into: self)
        }
    }

    func loadVideoPreview(key: String?) {
        guard let key = key else {
            return
        }
        let blankImageUrl = "https://img.youtube.com/vi/\(key)/0.jpg"
        if let imageUrl = URL(string: blankImageUrl) {
            Nuke.loadImage(with: imageUrl, into: self)
        }
    }
}

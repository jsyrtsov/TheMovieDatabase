//
//  PersonViewOutput.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/5/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

protocol PersonViewOutput: AnyObject {
    func loadData()
    func showFullPicture(picturePath: String?)
    func showDetailedMovie(movieId: Int?)
    func showImageViewer(images: [String?], currentImage: Int)
}

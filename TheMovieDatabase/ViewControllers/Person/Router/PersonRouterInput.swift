//
//  PersonRouterInput.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/5/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

protocol PersonRouterInput: AnyObject {
    func showFullPicture(picturePath: String?)
    func showDetailedMovie(movieId: Int?)
    // swiftlint:disable router_protocol_error
    func showImageViewer(images: [String?], currentImage: Int)
    // swiftlint:enable router_protocol_error
}

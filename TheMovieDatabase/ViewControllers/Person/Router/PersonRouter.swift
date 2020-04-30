//
//  PersonRouter.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/5/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

final class PersonRouter: PersonRouterInput {

    // MARK: - Properties

    weak var view: ModuleTransitionable?

    // MARK: - PersonRouterInput

    func showFullPictureScroll(images: [String?], currentImage: Int) {
        let fullPictureScrollVC = FullPictureScrollConfigurator().configure()
        fullPictureScrollVC.imagesArray = images
        fullPictureScrollVC.currentImage = currentImage
        view?.push(module: fullPictureScrollVC, animated: true, hideTabBar: true)
    }

    func showFullPicture(picturePath: String?) {
        let fullPictureVC = FullPictureModuleConfigurator().configure()
        fullPictureVC.picturePath = picturePath
        view?.push(module: fullPictureVC, animated: true, hideTabBar: true)
    }

    func showDetailedMovie(movieId: Int?) {
        let detailedMovieVC = DetailedMovieConfigurator().configure()
        detailedMovieVC.movieId = movieId
        view?.push(module: detailedMovieVC, animated: true)
    }
}

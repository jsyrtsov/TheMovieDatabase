//
//  PersonRouter.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/5/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

class PersonRouter: PersonRouterInput {

    // MARK: - Properties

    weak var view: ModuleTransitionable?

    // MARK: - PersonRouterInput

    func showFullPicture(picturePath: String?) {
        let fullPictureVC = FullPictureModuleConfigurator().configure()
        fullPictureVC.picturePath = picturePath
        view?.push(module: fullPictureVC, animated: true)
    }
}

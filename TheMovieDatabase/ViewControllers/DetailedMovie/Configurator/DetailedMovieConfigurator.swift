//
//  DetailedMovieConfigurator.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/7/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class DetailedMovieConfigurator {
    func configure() -> DetailedMovieViewController {
        guard
            let view = UIStoryboard(
                name: String(describing: DetailedMovieViewController.self), bundle: Bundle.main
            ).instantiateInitialViewController() as? DetailedMovieViewController
        else {
            fatalError(
                """
                Can't load DetailedMovieViewController from storyboard, check that controller is initial view controller
                """
            )
        }
        return view
    }
}

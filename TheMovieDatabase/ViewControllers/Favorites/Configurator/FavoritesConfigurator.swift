//
//  FavoritesConfigurator.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/15/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

final class FavoritesConfigurator {
    func configure() -> FavoritesViewController {
        guard
            let view = UIStoryboard(
                name: String(describing: FavoritesViewController.self), bundle: Bundle.main
            ).instantiateInitialViewController() as? FavoritesViewController
        else {
            fatalError(
                """
                Can't load FavoritesViewController from storyboard, check that controller is initial view controller
                """
            )
        }
        return view
    }
}

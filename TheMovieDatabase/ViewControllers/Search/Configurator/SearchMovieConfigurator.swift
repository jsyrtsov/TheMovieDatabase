//
//  SearchMovieConfigurator.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/15/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

final class SearchMovieConfigurator {
    func configure() -> SearchMovieViewController {
        guard
            let view = UIStoryboard(
                name: String(describing: SearchMovieViewController.self), bundle: Bundle.main
            ).instantiateInitialViewController() as? SearchMovieViewController
        else {
            fatalError(
                """
                Can't load SearchMovieViewController from storyboard, check that controller is initial view controller
                """
            )
        }
        return view
    }
}

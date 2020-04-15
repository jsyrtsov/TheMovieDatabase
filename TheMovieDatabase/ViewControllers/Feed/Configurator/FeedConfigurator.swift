//
//  FeedConfigurator.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/15/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

final class FeedConfigurator {
    func configure() -> FeedViewController {
        guard
            let view = UIStoryboard(
                name: String(describing: FeedViewController.self), bundle: Bundle.main
            ).instantiateInitialViewController() as? FeedViewController
        else {
            fatalError(
                """
                Can't load FeedViewController from storyboard, check that controller is initial view controller
                """
            )
        }
        return view
    }
}

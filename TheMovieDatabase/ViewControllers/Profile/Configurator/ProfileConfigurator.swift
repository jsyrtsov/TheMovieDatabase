//
//  ProfileConfigurator.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/17/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

final class ProfileConfigurator {
    func configure() -> ProfileViewController {
        guard
            let view = UIStoryboard(
                name: String(describing: ProfileViewController.self), bundle: Bundle.main
            ).instantiateInitialViewController() as? ProfileViewController
        else {
            fatalError(
                """
                Can't load ProfileViewController from storyboard, check that controller is initial view controller
                """
            )
        }
        return view
    }
}

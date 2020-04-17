//
//  AuthorizationConfigurator.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/17/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

final class AuthorizationConfigurator {
    func configure() -> AuthorizationViewController {
        guard
            let view = UIStoryboard(
                name: String(describing: AuthorizationViewController.self), bundle: Bundle.main
            ).instantiateInitialViewController() as? AuthorizationViewController
        else {
            fatalError(
                """
                Can't load AuthorizationViewController from storyboard, check that controller is initial view controller
                """
            )
        }
        return view
    }
}

//
//  FullPictureModuleConfigurator.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/5/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class FullPictureModuleConfigurator {
    func configure() -> FullPictureViewController {
        guard
            let view = UIStoryboard(
                name: String(describing: FullPictureViewController.self), bundle: Bundle.main
            ).instantiateInitialViewController() as? FullPictureViewController
        else {
            fatalError(
                "Can't load FullPictureViewController from storyboard, check that controller is initial view controller"
            )
        }
        return view
    }
}

//
//  PersonModuleConfigurator.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/4/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

final class PersonModuleConfigurator {
    func configure(personId: Int?) -> PersonViewController {
        guard
            let view = UIStoryboard(
                name: String(describing: PersonViewController.self), bundle: Bundle.main
            ).instantiateInitialViewController() as? PersonViewController
        else {
            fatalError(
                "Can't load PersonViewController from storyboard, check that controller is initial view controller"
            )
        }
        let router = PersonRouter()
        let presenter = PersonPresenter()
        presenter.configure(personId: personId)
        router.view = view
        presenter.router = router
        view.output = presenter
        presenter.view = view
        return view
    }
}

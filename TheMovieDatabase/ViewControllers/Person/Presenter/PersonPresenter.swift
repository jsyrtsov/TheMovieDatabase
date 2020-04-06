//
//  PersonPresenter.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/4/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

class PersonPresenter: PersonViewOutput, PersonModuleInput {

    // MARK: - Properties

    weak var view: PersonViewInput?
    var router: PersonRouterInput?
    private let service = PersonLoadingService()
    private var personId: Int?

    // MARK: - PersonModuleInput

    func configure(personId: Int?) {
        self.personId = personId
    }

    // MARK: - PersonViewOutput

    func showFullPicture(picturePath: String?) {
        router?.showFullPicture(picturePath: picturePath)
    }

    func loadPersonDetails() {
        guard let personId = personId else {
            return
        }
        service.loadPerson(personId: personId) { [weak self] (result) in
            guard let result = result, let self = self else {
                return
            }
            self.view?.configure(withPerson: result)
        }
        service.loadPersonImages(personId: personId) { [weak self] (result) in
            guard let result = result, let self = self else {
                return
            }
            self.view?.configure(withPersonImages: result)
        }
    }

    func loadPersonCredits() {
        guard let personId = personId else {
            return
        }
        service.loadPersonCredits(personId: personId) { [weak self] (personCast, personCrew) in
            guard
                let personCast = personCast,
                let personCrew = personCrew,
                let self = self
            else {
                return
            }
            self.view?.configure(withPersonCredits: personCast, personCrew: personCrew)
        }
    }
}

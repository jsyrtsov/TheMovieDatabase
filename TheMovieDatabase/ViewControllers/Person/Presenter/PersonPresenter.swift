//
//  PersonPresenter.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/4/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

class PersonPresenter {
    weak var view: PersonViewController?
    private let service = PersonLoadingService()
    private let personId: Int?
    init(personId: Int?) {
        self.personId = personId
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
}

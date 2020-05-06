//
//  PersonPresenter.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/4/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import Foundation

final class PersonPresenter: PersonViewOutput, PersonModuleInput {

    // MARK: - Properties

    weak var view: PersonViewInput?
    var router: PersonRouterInput?
    private let service = PersonService()
    private var personId: Int?
    private var personDetails: Person?
    private var personCast: [PersonMovie] = []
    private var personCrew: [PersonMovie] = []
    private var personImages: [PersonImage] = []

    // MARK: - PersonModuleInput

    func configure(personId: Int?) {
        self.personId = personId
    }

    // MARK: - PersonViewOutput

    func showImageViewer(images: [String?], currentImage: Int) {
        router?.showImageViewer(images: images, currentImage: currentImage)
    }

    func showFullPicture(picturePath: String?) {
        router?.showFullPicture(picturePath: picturePath)
    }

    func showDetailedMovie(movieId: Int?) {
        router?.showDetailedMovie(movieId: movieId)
    }

    func loadData() {
        guard let personId = personId else {
            return
        }
        let loadDataGroup = DispatchGroup()
        loadDataGroup.enter()
        service.loadPerson(personId: personId) { [weak self] (result) in
            guard let self = self, let result = result else {
                return
            }
            self.personDetails = result
            loadDataGroup.leave()
        }
        loadDataGroup.enter()
        service.loadPersonCredits(personId: personId) { [weak self] (personCast, personCrew) in
            guard
                let self = self,
                let personCast = personCast,
                let personCrew = personCrew
            else {
                return
            }
            self.personCast = personCast
            self.personCrew = personCrew
            loadDataGroup.leave()
        }
        loadDataGroup.enter()
        service.loadPersonImages(personId: personId) { [weak self] (result) in
            guard let self = self, let result = result else {
                return
            }
            self.personImages = result
            loadDataGroup.leave()
        }
        loadDataGroup.notify(queue: .main) {
            self.view?.configure(withPerson: self.personDetails)
            self.view?.configure(personCast: self.personCast, personCrew: self.personCrew)
            self.view?.configure(withPersonImages: self.personImages)
        }
    }
}

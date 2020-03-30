//
//  PersonViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/27/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {

    var personId: Int?
    private let service = MoviesLoadingService()
    private var person: Person?

    @IBOutlet weak private var name: UILabel!
    @IBOutlet weak private var birthday: UILabel!
    @IBOutlet weak private var placeOfBirth: UILabel!
    @IBOutlet weak private var profileImage: UIImageView!
    @IBOutlet weak private var baseInfoShadow: UIView!
    @IBOutlet weak private var additionalInfoShadow: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadPersonDetails()
    }

    private func loadPersonDetails() {
        guard let personId = personId else {
            return
        }
        service.loadPerson(personId: personId) { [weak self] (result) in
            guard let result = result, let self = self else {
                return
            }
            self.person = result
            self.updateView()
        }
    }

    private func configureView() {
        profileImage.layer.cornerRadius = 5
        profileImage.clipsToBounds = true
        baseInfoShadow.layer.cornerRadius = 10
        baseInfoShadow.applyShadow(radius: 10, opacity: 0.08, offsetW: 4, offsetH: 4)
        additionalInfoShadow.layer.cornerRadius = 20
        additionalInfoShadow.applyShadow(radius: 10, opacity: 0.08, offsetW: 4, offsetH: 4)
    }

    private func updateView() {
        name.text = person?.name
        birthday.text = person?.birthday
        placeOfBirth.text = person?.placeOfBirth
        profileImage.loadPicture(posterPath: person?.profilePath)
    }
}

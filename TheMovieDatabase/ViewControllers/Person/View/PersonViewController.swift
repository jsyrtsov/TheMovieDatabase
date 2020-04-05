//
//  PersonViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/27/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit
import ExpandableLabel

class PersonViewController: UIViewController {

    static let identifier = String(describing: PersonViewController.self)

    var personId: Int?
    var presenter: PersonPresenter?
    private let service = PersonLoadingService()
    private var person: Person?
    private var personImages: [PersonImage] = []

    @IBOutlet weak private var name: UILabel!
    @IBOutlet weak private var birthday: UILabel!
    @IBOutlet weak private var placeOfBirth: UILabel!
    @IBOutlet weak private var biography: ExpandableLabel!
    @IBOutlet weak private var profileImage: UIImageView!
    @IBOutlet weak private var baseInfoShadow: UIView!
    @IBOutlet weak private var additionalInfoShadow: UIView!
    @IBOutlet weak private var imagesCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        presenter?.loadPersonDetails()
    }

    func configure(withPerson person: Person?) {
        self.person = person
        self.updateView()
    }

    func configure(withPersonImages personImages: [PersonImage]) {
        self.personImages = personImages
        self.imagesCollectionView.reloadData()
    }

    private func configureView() {
        biography.shouldCollapse = true
        biography.numberOfLines = 6
        biography.collapsedAttributedLink = NSAttributedString(
            string: "Show more", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        )
        biography.expandedAttributedLink = NSAttributedString(
            string: "Show less", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        )

        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.register(UINib(nibName: PersonImagesCollectionViewCell.identifier, bundle: nil),
                                      forCellWithReuseIdentifier: PersonImagesCollectionViewCell.identifier)

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
        biography.text = person?.biography
    }
}

// MARK: - UICollectionViewDataSource

extension PersonViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return personImages.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PersonImagesCollectionViewCell.identifier,
            for: indexPath
        ) as? PersonImagesCollectionViewCell
        cell?.configure(personImage: personImages[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension PersonViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDelegateFlowLayout

extension PersonViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imagesCollectionView {
            return PersonImagesCollectionViewCell.size
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
}

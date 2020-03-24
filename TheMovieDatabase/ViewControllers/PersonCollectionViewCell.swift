//
//  PersonCollectionViewCell.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private var baseShadowView: UIView!
    @IBOutlet weak private var profileImage: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var characterOrJobLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    func configureCast(castEntry: CastEntry) {
        profileImage.loadPicture(posterPath: castEntry.profilePath)
        nameLabel.text = castEntry.name
        characterOrJobLabel.text = castEntry.character
    }

    func configureCrew(crewEntry: CrewEntry) {
        nameLabel.text = crewEntry.name
        characterOrJobLabel.text = crewEntry.job
        profileImage.loadPicture(posterPath: crewEntry.profilePath)
    }

    private func configureView() {
        profileImage.layer.cornerRadius = 5
        baseShadowView.layer.cornerRadius = 5
        baseShadowView.applyShadow(radius: 6, opacity: 0.07, offsetW: 3, offsetH: 3)
    }
}

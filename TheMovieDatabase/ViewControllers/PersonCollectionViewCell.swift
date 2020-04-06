//
//  PersonCollectionViewCell.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: PersonCollectionViewCell.self)
    static let size = CGSize(width: 143, height: 85)

    @IBOutlet weak private var baseShadowView: UIView!
    @IBOutlet weak private var profileImage: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var characterOrJobLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    func configureCast(castEntry: CastEntry) {
        if castEntry.profilePath == nil {
            profileImage.image = #imageLiteral(resourceName: "person")
        } else {
            profileImage.loadPicture(posterPath: castEntry.profilePath)
        }
        nameLabel.text = castEntry.name
        characterOrJobLabel.text = castEntry.character
    }

    func configureCrew(crewEntry: CrewEntry) {
        if crewEntry.profilePath == nil {
            profileImage.image = #imageLiteral(resourceName: "person")
        } else {
            profileImage.loadPicture(posterPath: crewEntry.profilePath)
        }
        nameLabel.text = crewEntry.name
        characterOrJobLabel.text = crewEntry.job
    }

    private func configureView() {
        profileImage.layer.cornerRadius = 5
        baseShadowView.layer.cornerRadius = 5
        baseShadowView.applyShadow(radius: 6, opacity: 0.07, offsetW: 3, offsetH: 3)
    }
}

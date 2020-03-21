//
//  CrewCollectionViewCell.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class CrewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private var name: UILabel!
    @IBOutlet weak private var job: UILabel!
    @IBOutlet weak private var baseShadowView: UIView!
    @IBOutlet weak private var profileImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    private func configureView() {
        profileImage.layer.cornerRadius = 5
        baseShadowView.layer.cornerRadius = 5
        baseShadowView.applyShadow(radius: 6, opacity: 0.07, offsetW: 3, offsetH: 3)
    }

    func configure(crewEntry: CrewEntry) {
        name.text = crewEntry.name
        job.text = crewEntry.job
        profileImage.loadPicture(withPosterPath: crewEntry.profilePath)
    }
}

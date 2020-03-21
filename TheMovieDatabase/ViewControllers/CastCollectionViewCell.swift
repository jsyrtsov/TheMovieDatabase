//
//  PersonCollectionViewCell.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private var baseShadowView: UIView!
    @IBOutlet weak private var faceView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var characterLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    private func configureView() {
        faceView.layer.cornerRadius = 5
        baseShadowView.layer.cornerRadius = 5
        baseShadowView.applyShadow(radius: 6, opacity: 0.07, offsetW: 3, offsetH: 3)
    }

    func configure(castEntry: CastEntry) {
        faceView.loadPicture(withPosterPath: castEntry.profilePath)
        nameLabel.text = castEntry.name
        characterLabel.text = castEntry.character
    }
}

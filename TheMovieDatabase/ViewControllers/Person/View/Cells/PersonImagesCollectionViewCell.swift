//
//  PersonImagesCollectionViewCell.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/30/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class PersonImagesCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: PersonImagesCollectionViewCell.self)
    static let size = CGSize(width: 51, height: 77)

    @IBOutlet weak private var profileImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    func configure(personImage: PersonImage) {
        profileImage.loadPicture(posterPath: personImage.filePath)
    }

    private func configureUI() {
        profileImage.layer.cornerRadius = 4
        profileImage.clipsToBounds = true
    }
}

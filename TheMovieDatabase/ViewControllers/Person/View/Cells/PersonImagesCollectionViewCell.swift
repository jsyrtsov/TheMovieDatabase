//
//  PersonImagesCollectionViewCell.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/30/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

final class PersonImagesCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    static let identifier = String(describing: PersonImagesCollectionViewCell.self)
    static let size = CGSize(width: 51, height: 77)

    // MARK: - Subviews

    @IBOutlet weak private var profileImage: UIImageView!

    // MARK: - UICollectionViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    // MARK: - Methods

    func configure(personImage: PersonImage) {
        profileImage.loadPicture(posterPath: personImage.filePath)
    }

    // MARK: - Private Methods

    private func configureUI() {
        profileImage.layer.cornerRadius = 4
        profileImage.clipsToBounds = true
    }
}

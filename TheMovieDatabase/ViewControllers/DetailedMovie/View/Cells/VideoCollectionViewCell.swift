//
//  VideoCollectionViewCell.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/23/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

final class VideoCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    static let identifier = String(describing: VideoCollectionViewCell.self)
    static let size = CGSize(width: 179, height: 130)

    // MARK: - Subviews

    @IBOutlet weak private var baseShadowView: UIView!
    @IBOutlet weak private var imageShadowView: UIView!
    @IBOutlet weak private var previewImage: UIImageView!
    @IBOutlet weak private var title: UILabel!

    // MARK: - UICollectionViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    // MARK: - Methods

    func configure(video: Video) {
        previewImage.loadVideoPreview(key: video.key)
        title.text = video.name
    }

    // MARK: - Private Methods

    private func configureView() {
        previewImage.layer.cornerRadius = 5
        previewImage.clipsToBounds = true
        imageShadowView.layer.cornerRadius = 5
        imageShadowView.applyShadow(radius: 6, opacity: 0.07, offsetW: 3, offsetH: 3)
        baseShadowView.layer.cornerRadius = 5
        baseShadowView.applyShadow(radius: 6, opacity: 0.07, offsetW: 3, offsetH: 3)
    }
}

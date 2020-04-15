//
//  PersonMovieTableViewCell.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/6/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

final class PersonMovieTableViewCell: UITableViewCell {

    // MARK: - Properties

    static let identifier = String(describing: PersonMovieTableViewCell.self)

    // MARK: - Subviews

    @IBOutlet weak private var baseShadowView: UIView!
    @IBOutlet weak private var posterImage: UIImageView!
    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var characterOrJob: UILabel!
    @IBOutlet weak private var voteAverage: UILabel!
    @IBOutlet weak private var releaseDate: UILabel!

    // MARK: - UITableViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    // MARK: - Methods

    func configure(personMovie: PersonMovie) {
        if personMovie.posterPath == nil {
            posterImage.image = #imageLiteral(resourceName: "moviePosterPlaceHolder")
            posterImage.backgroundColor = UIColor(red: 244 / 255,
                                                  green: 244 / 255,
                                                  blue: 244 / 255,
                                                  alpha: 1)
        } else {
            posterImage.loadPicture(posterPath: personMovie.posterPath)
        }
        title.text = personMovie.title
        if personMovie.job == nil {
            characterOrJob.text = personMovie.character
        } else {
            characterOrJob.text = personMovie.job
        }
        if let vote = personMovie.voteAverage {
            voteAverage.text = String(vote)
            voteAverage.textColor = UIColor.color(forVote: vote)
        }
        if let yearStr = personMovie.releaseDate?.prefix(4) {
            releaseDate.text = String(yearStr)
        }
    }

    // MARK: - Private Methods

    private func configureUI() {
        baseShadowView.applyShadow(radius: 6, opacity: 0.06, offsetW: 2, offsetH: 2)
        baseShadowView.layer.cornerRadius = 5
        posterImage.layer.cornerRadius = 3
    }
}

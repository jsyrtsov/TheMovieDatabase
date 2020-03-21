//
//  MovieTableViewCell.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/16/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak private var cellView: UIView!
    @IBOutlet weak private var shadowImageView: UIView!
    @IBOutlet weak private var shadowCellView: UIView!
    @IBOutlet weak private var posterImageView: UIImageView!
    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var overview: UILabel!
    @IBOutlet weak private var year: UILabel!
    @IBOutlet weak private var voteAverage: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    func configure(movie: Movie) {
        title.text = movie.title
        overview.text = movie.overview
        guard let vote = movie.voteAverage else {
            return
        }
        voteAverage.text = String(vote)
        guard let yearStr = movie.releaseDate?.prefix(4) else {
            return
        }
        year.text = String(yearStr)
        posterImageView.loadPicture(withPosterPath: movie.posterPath)

        if vote > 7.5 {
            voteAverage.textColor = UIColor(red: 30 / 255,
                                            green: 134 / 255,
                                            blue: 53 / 255,
                                            alpha: 1)
        } else if vote == 0.0 {
            voteAverage.textColor = UIColor(red: 124 / 255,
                                            green: 124 / 255,
                                            blue: 124 / 255,
                                            alpha: 1)
        } else if vote < 6.0 {
            voteAverage.textColor = UIColor(red: 155 / 255,
                                            green: 36 / 255,
                                            blue: 36 / 255,
                                            alpha: 1)
        } else {
            voteAverage.textColor = UIColor(red: 124 / 255,
                                            green: 124 / 255,
                                            blue: 124 / 255,
                                            alpha: 1)
        }
    }

    private func configureUI() {
        cellView.layer.cornerRadius = 10

        posterImageView.layer.cornerRadius = 5
        posterImageView.clipsToBounds = true

        shadowImageView.applyShadow(radius: 5, opacity: 0.25, offsetW: 1, offsetH: 0)
        shadowImageView.layer.cornerRadius = 5

        shadowCellView.applyShadow(radius: 6, opacity: 0.1, offsetW: 4, offsetH: 4)
        shadowCellView.layer.cornerRadius = 10
    }
}

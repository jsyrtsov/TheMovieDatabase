//
//  MovieTableViewCell.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/16/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    static let identifier = String(describing: MovieTableViewCell.self)

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
        if let vote = movie.voteAverage {
            voteAverage.text = String(vote)
            voteAverage.textColor = UIColor.colorForVote(vote: vote)
        }
        if let yearStr = movie.releaseDate?.prefix(4) {
            year.text = String(yearStr)
        }
        posterImageView.loadPicture(posterPath: movie.posterPath)
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

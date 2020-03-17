//
//  NewMovieTableViewCell.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/16/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class NewMovieTableViewCell: UITableViewCell {

    @IBOutlet weak private var cellView: UIView!
    @IBOutlet weak private var shadowImageView: UIView!
    @IBOutlet weak private var shadowCellView: UIView!
    @IBOutlet weak private var posterImageView: UIImageView!
    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var overview: UILabel!
    @IBOutlet weak private var year: UILabel!
    @IBOutlet weak private var voteAverage: UILabel!

    private var vote: Double = 0.0

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
        self.vote = vote
        voteAverage.text = String(self.vote)
        guard let yearStr = movie.releaseDate?.prefix(4) else {
            return
        }
        year.text = String(yearStr)
        posterImageView.loadPoster(withPosterPath: movie.posterPath)

        if vote > 7.5 {
            voteAverage.textColor = UIColor(red: 30 / 255,
                                            green: 134 / 255,
                                            blue: 53 / 255,
                                            alpha: 1)
        } else if vote == 0.0 {
            voteAverage.isHidden = true
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
        posterImageView.layer.cornerRadius = 5
        posterImageView.clipsToBounds = true

        shadowImageView.layer.cornerRadius = 5
        let color: UIColor = .black
        shadowImageView.layer.shadowColor = color.cgColor
        shadowImageView.layer.shadowOpacity = 0.25
        shadowImageView.layer.masksToBounds = false
        shadowImageView.layer.shadowOffset = CGSize(width: 1, height: 0)
        shadowImageView.layer.shadowRadius = 5

        cellView.layer.cornerRadius = 10
        shadowCellView.layer.cornerRadius = 10
        shadowCellView.layer.masksToBounds = false
        shadowCellView.layer.shadowColor = color.cgColor
        shadowCellView.layer.shadowOpacity = 0.1
        shadowCellView.layer.shadowOffset = CGSize(width: 4, height: 4)
        shadowCellView.layer.shadowRadius = 6
    }
}

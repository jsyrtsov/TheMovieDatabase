//
//  MovieTableViewCell.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/27/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak private var movieImageView: UIImageView!
    @IBOutlet weak private var movieNameLabel: UILabel!
    @IBOutlet weak private var movieDescriptionLabel: UILabel!

    func configure (withMovie movie: Movie) {
        movieNameLabel.text = movie.title
        movieDescriptionLabel.text = movie.overview
        movieImageView.loadPoster(withPosterPath: movie.posterPath)
    }

    func configure (withObject movie: MovieObject) {
        movieNameLabel.text = movie.title
        movieDescriptionLabel.text = movie.overview
        movieImageView.loadPoster(withPosterPath: movie.posterPath)
    }
}

//TEST COMMIT

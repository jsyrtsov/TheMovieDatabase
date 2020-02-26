//
//  MovieTableViewCell.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit
import Nuke

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak private var movieImage: UIImageView!
    @IBOutlet weak private var movieNameLabel: UILabel!
    @IBOutlet weak private var movieDescriptionLabel: UILabel!

    func configure (withMovie movie: Movie) {
        movieNameLabel.text = movie.title
        movieDescriptionLabel.text = movie.overview
        movieImage.loadPoster(withPosterPath: movie.posterPath)
    }
}

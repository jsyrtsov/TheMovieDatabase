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

    func configureCell (withMovie movie: Movie) {

        let blankImageUrl = "https://image.tmdb.org/t/p/w500"
        movieNameLabel.text = movie.title
        movieDescriptionLabel.text = movie.overview
        if let imageUrlString = movie.posterPath,
            let imageUrl = URL(string: blankImageUrl + imageUrlString) {

            Nuke.loadImage(with: imageUrl, into: movieImage)
        }
    }
}

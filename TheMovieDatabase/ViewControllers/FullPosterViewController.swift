//
//  FullPosterViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/4/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class FullPosterViewController: UIViewController {

    var movieId: Int?
    var posterPath: String?

    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadPic()
    }

    private func configureView() {
        activityIndicator.startAnimating()
    }

    private func loadPic() {
        imageView.loadFullPicture(path: posterPath)
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}

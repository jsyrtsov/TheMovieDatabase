//
//  DetailedViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/22/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    var movieId: Int?
    private let service = DetailedMovieLoadingService()
    private var details: DetailedMovie?

    @IBOutlet weak private var playTrailerButton: UIButton!
    @IBOutlet weak private var showImagesButton: UIButton!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var budgetLabel: UILabel!
    @IBOutlet weak private var revenueLabel: UILabel!
    @IBOutlet weak private var runtimeLabel: UILabel!
    @IBOutlet weak private var originalLangLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadDetails()
    }

    private func configureView() {
        playTrailerButton.isHidden = true
        showImagesButton.isHidden = true
        playTrailerButton.layer.borderColor = UIColor.gray.cgColor
        playTrailerButton.layer.borderWidth = 0.5
        showImagesButton.layer.borderColor = UIColor.gray.cgColor
        showImagesButton.layer.borderWidth = 0.5
        navigationItem.largeTitleDisplayMode = .never
        activityIndicator.startAnimating()
        imageView.isHidden = true
        descriptionLabel.isHidden = true
        budgetLabel.isHidden = true
        revenueLabel.isHidden = true
        runtimeLabel.isHidden = true
        originalLangLabel.isHidden = true
    }

    private func loadDetails() {
        guard let movieId = movieId else {
            return
        }
        service.loadDetails(withMovieId: movieId) { (result) in
            guard let result = result else {
                return
            }
            self.details = result
            self.updateView()
        }
    }

    private func updateView() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        imageView.isHidden = false
        descriptionLabel.isHidden = false
        budgetLabel.isHidden = false
        revenueLabel.isHidden = false
        runtimeLabel.isHidden = false
        originalLangLabel.isHidden = false
        nameLabel.text = details?.title
        descriptionLabel.text = details?.overview
        if details?.budget == 0 {
            budgetLabel.text = "Information is coming soon"
        } else {
            budgetLabel.text = "\(details?.budget ?? 0)$"
        }
        if details?.revenue == 0 {
            revenueLabel.text = "Information is coming soon"
        } else {
            revenueLabel.text = "\(details?.revenue ?? 0)$"
        }
        if let runtime = details?.runtime {
            let runtimeHours = runtime / 60
            let runtimeMins = runtime % 60
            runtimeLabel.text = "\(runtimeHours)h \(runtimeMins)m"
        }
        originalLangLabel.text = details?.originalLanguage
        imageView.loadPoster(withPosterPath: details?.posterPath)
    }

    @IBAction private func playTrailerPressed(_ sender: Any) {

    }

    @IBAction private func showImagesPressed(_ sender: Any) {
    }
}

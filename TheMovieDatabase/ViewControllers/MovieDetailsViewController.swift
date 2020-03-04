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

    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var budgetLabel: UILabel!
    @IBOutlet weak private var revenueLabel: UILabel!
    @IBOutlet weak private var runtimeLabel: UILabel!
    @IBOutlet weak private var originalLangLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetails()
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
            self.configureView()
        }
    }
    private func configureView() {
        nameLabel.text = details?.title
        descriptionLabel.text = details?.overview
        switch details?.budget {
        case 0:
            budgetLabel.text = "Information is coming soon"
        default:
            budgetLabel.text = "\(details?.budget ?? 0)$"
        }
        switch details?.revenue {
        case 0:
            revenueLabel.text = "Information is coming soon"
        default:
            revenueLabel.text = "\(details?.revenue ?? 0)$"
        }
        runtimeLabel.text = "\(details?.runtime ?? 0)"
        originalLangLabel.text = details?.originalLanguage
        imageView.loadPoster(withPosterPath: details?.posterPath)
    }
}

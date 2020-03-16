//
//  DetailedViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/22/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class DetailedMovieViewController: UIViewController {

    var movieId: Int?
    private let storageService = StorageService()
    private let service = MoviesLoadingService()
    private var detailedMovie: DetailedMovie?
    private var isFavorite = false
    private var buttonImage = #imageLiteral(resourceName: "likeUntatted")
    private let likeButton = UIButton(type: .custom)

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkLike()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadDetails()
    }

    private func configureView() {
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

        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true

        likeButton.setImage(buttonImage, for: .normal)
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: likeButton)
        navigationItem.rightBarButtonItem = barButtonItem
    }

    private func loadDetails() {
        guard let movieId = movieId else {
            return
        }
        service.loadDetails(withMovieId: movieId) { [weak self] (result) in
            guard let result = result, let self = self else {
                return
            }
            self.detailedMovie = result
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

        nameLabel.text = detailedMovie?.title
        descriptionLabel.text = detailedMovie?.overview
        if detailedMovie?.budget == 0 {
            budgetLabel.text = "Information is coming soon"
        } else {
            budgetLabel.text = "\(detailedMovie?.budget ?? 0)$"
        }
        if detailedMovie?.revenue == 0 {
            revenueLabel.text = "Information is coming soon"
        } else {
            revenueLabel.text = "\(detailedMovie?.revenue ?? 0)$"
        }
        if let runtime = detailedMovie?.runtime {
            let runtimeHours = runtime / 60
            let runtimeMins = runtime % 60
            runtimeLabel.text = "\(runtimeHours)h \(runtimeMins)m"
        }
        originalLangLabel.text = detailedMovie?.originalLanguage
        imageView.loadPoster(withPosterPath: detailedMovie?.posterPath)
    }

    @objc
    private func imageTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let fullViewVC = storyboard.instantiateViewController(withIdentifier: "FullPosterViewController")
            as? FullPosterViewController  else {
            return
        }
        navigationController?.pushViewController(fullViewVC, animated: true)
        fullViewVC.movieId = detailedMovie?.id
        fullViewVC.posterPath = detailedMovie?.posterPath
    }

    @objc
    private func likeTapped() {
        var detailedMovieObject: DetailedMovieObject?
        var movieObject: MovieObject?
        movieObject = MovieObject(id: detailedMovie?.id,
                                  posterPath: detailedMovie?.posterPath,
                                  title: detailedMovie?.title,
                                  overview: detailedMovie?.overview)

        detailedMovieObject = DetailedMovieObject(title: detailedMovie?.title,
                                                  overview: detailedMovie?.overview,
                                                  posterPath: detailedMovie?.posterPath,
                                                  originalLanguage: detailedMovie?.originalLanguage,
                                                  runtime: detailedMovie?.runtime,
                                                  budget: detailedMovie?.budget,
                                                  revenue: detailedMovie?.revenue,
                                                  id: detailedMovie?.id)

        if isFavorite {
            isFavorite = false
            buttonImage = #imageLiteral(resourceName: "likeUntatted")
            likeButton.setImage(buttonImage, for: .normal)
            storageService.removeObjectWithId(object: MovieObject.self, id: movieId)
            storageService.removeObjectWithId(object: DetailedMovieObject.self, id: movieId)
        } else {
            isFavorite = true
            buttonImage = #imageLiteral(resourceName: "likeTapped")
            likeButton.setImage(buttonImage, for: .normal)
            storageService.saveObject(object: detailedMovieObject)
            storageService.saveObject(object: movieObject)
        }
    }

    private func checkLike() {
        if storageService.ckeckLike(object: MovieObject.self, id: movieId) {
            isFavorite = true
            buttonImage = #imageLiteral(resourceName: "likeTapped")
            likeButton.setImage(buttonImage, for: .normal)
        } else {
            isFavorite = false
            buttonImage = #imageLiteral(resourceName: "likeUntatted")
            likeButton.setImage(buttonImage, for: .normal)
        }
    }

    @IBAction private func playTrailerPressed(_ sender: Any) {
    }

    @IBAction private func showImagesPressed(_ sender: Any) {
    }
}

//
//  NewDetailedMovieViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class NewDetailedMovieViewController: UIViewController {

    var movieId: Int?
    private let service = MoviesLoadingService()
    private var detailedMovie: DetailedMovie?

    @IBOutlet weak private var overviewLabel: UILabel!
    @IBOutlet weak private var releaseYearLabel: UILabel!
    @IBOutlet weak private var voteLabel: UILabel!
    @IBOutlet weak private var taglineLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var imageShadowView: UIView!
    @IBOutlet weak private var backdropImage: UIImageView!
    @IBOutlet weak private var baseShadowView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadDetails()
    }

    private func configureView() {
        backdropImage.clipsToBounds = true
        backdropImage.layer.cornerRadius = 10
        configureShadows()
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
        backdropImage.loadFullPic(withPath: detailedMovie?.backdropPath)
        guard let date = detailedMovie?.releaseDate?.prefix(4), let vote = detailedMovie?.voteAverage else {
            return
        }
        if vote > 7.5 {
            voteLabel.textColor = UIColor(red: 30 / 255,
                                            green: 134 / 255,
                                            blue: 53 / 255,
                                            alpha: 1)
        } else if vote == 0.0 {
            voteLabel.textColor = UIColor(red: 124 / 255,
                                            green: 124 / 255,
                                            blue: 124 / 255,
                                            alpha: 1)
        } else if vote < 6.0 {
            voteLabel.textColor = UIColor(red: 155 / 255,
                                            green: 36 / 255,
                                            blue: 36 / 255,
                                            alpha: 1)
        } else {
            voteLabel.textColor = UIColor(red: 124 / 255,
                                            green: 124 / 255,
                                            blue: 124 / 255,
                                            alpha: 1)
        }
        releaseYearLabel.text = String(date)
        taglineLabel.text = detailedMovie?.tagline
        overviewLabel.text = detailedMovie?.overview
        voteLabel.text = String(vote)
        titleLabel.text = detailedMovie?.title
    }

    private func configureShadows() {
        let color: UIColor = .black

        baseShadowView.layer.masksToBounds = false
        baseShadowView.layer.cornerRadius = 20
        baseShadowView.layer.shadowOffset = CGSize(width: 4, height: 4)
        baseShadowView.layer.shadowOpacity = 0.1
        baseShadowView.layer.shadowColor = color.cgColor
        baseShadowView.layer.shadowRadius = 20

        imageShadowView.layer.masksToBounds = false
        imageShadowView.layer.cornerRadius = 10
        imageShadowView.layer.shadowOffset = CGSize(width: 2, height: 2)
        imageShadowView.layer.shadowOpacity = 0.2
        imageShadowView.layer.shadowColor = color.cgColor
        imageShadowView.layer.shadowRadius = 10
    }
}

extension NewDetailedMovieViewController: UICollectionViewDelegate {

}

extension NewDetailedMovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

}

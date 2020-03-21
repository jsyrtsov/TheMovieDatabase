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
    private var cast: [CastEntry] = []
    private let personCell = "personCell"

    @IBOutlet weak private var overviewLabel: UILabel!
    @IBOutlet weak private var releaseYearLabel: UILabel!
    @IBOutlet weak private var voteLabel: UILabel!
    @IBOutlet weak private var taglineLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var imageShadowView: UIView!
    @IBOutlet weak private var backdropImage: UIImageView!
    @IBOutlet weak private var baseShadowView: UIView!
    @IBOutlet weak private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadDetails()
    }

    private func configureView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        backdropImage.clipsToBounds = true
        backdropImage.layer.cornerRadius = 10
        collectionView.register(UINib(nibName: "PersonCollectionViewCell",
                                      bundle: nil), forCellWithReuseIdentifier: personCell)
        configureShadows()
    }

    private func loadDetails() {
        guard let movieId = movieId else {
            return
        }
        service.loadCast(movieId: movieId) { [weak self] (result) in
        guard let result = result, let self = self else {
                return
            }
            self.cast = result
            self.collectionView.reloadData()
        }
        service.loadDetails(movieId: movieId) { [weak self] (result) in
            guard let result = result, let self = self else {
                return
            }
            self.detailedMovie = result
            self.updateView()
        }
    }

    private func updateView() {
        backdropImage.loadFullPicture(withPath: detailedMovie?.backdropPath)
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
        baseShadowView.applyShadow(radius: 20, opacity: 0.1, offsetW: 4, offsetH: 4)
        baseShadowView.layer.cornerRadius = 20

        imageShadowView.applyShadow(radius: 10, opacity: 0.2, offsetW: 2, offsetH: 2)
        imageShadowView.layer.cornerRadius = 10
    }
}

extension NewDetailedMovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension NewDetailedMovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cast.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: personCell,
                                                      for: indexPath) as? PersonCollectionViewCell
        cell?.configure(castEntry: cast[indexPath.row])
        return cell ?? UICollectionViewCell()
    }

}

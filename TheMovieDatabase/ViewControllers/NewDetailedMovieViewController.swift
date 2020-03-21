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
    private let castCell = "castCell"
    private var isFavorite = false
    private let favoriteButton = UIButton(type: .custom)

    @IBOutlet weak private var runtime: UILabel!
    @IBOutlet weak private var revenue: UILabel!
    @IBOutlet weak private var budget: UILabel!
    @IBOutlet weak private var originalLanguage: UILabel!
    @IBOutlet weak private var releaseDate: UILabel!
    @IBOutlet weak private var overviewLabel: UILabel!
    @IBOutlet weak private var releaseYearLabel: UILabel!
    @IBOutlet weak private var voteLabel: UILabel!
    @IBOutlet weak private var taglineLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var imageShadowView: UIView!
    @IBOutlet weak private var backdropImage: UIImageView!
    @IBOutlet weak private var baseShadowView: UIView!
    @IBOutlet weak private var collectionViewCast: UICollectionView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkFavorite()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadDetails()
    }

    private func configureView() {
        collectionViewCast.delegate = self
        collectionViewCast.dataSource = self
        backdropImage.clipsToBounds = true
        backdropImage.layer.cornerRadius = 10
        collectionViewCast.register(UINib(nibName: "CastCollectionViewCell",
                                      bundle: nil), forCellWithReuseIdentifier: castCell)
        configureShadows()

        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        backdropImage.addGestureRecognizer(tap)
        backdropImage.isUserInteractionEnabled = true

        favoriteButton.setImage(#imageLiteral(resourceName: "likeUntatted"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: favoriteButton)
        navigationItem.rightBarButtonItem = barButtonItem
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
            self.collectionViewCast.reloadData()
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
        if detailedMovie?.budget == 0 {
            budget.text = "Information is coming soon"
        } else {
            budget.text = "\(detailedMovie?.budget ?? 0)$"
        }
        if detailedMovie?.revenue == 0 {
            revenue.text = "Information is coming soon"
        } else if let revenue = detailedMovie?.revenue {

            let revenueB = revenue / 1000000000
            let revenueM = revenue / 1000000
            let revenueT = revenue / 1000
            let revenueH = revenue % 1000
            self.revenue.text = "\(revenueB)B \(revenueM)M \(revenueT)T \(revenueH)$"
            //revenue.text = "\(detailedMovie?.revenue ?? 0)$"
        }
        if let runtime = detailedMovie?.runtime {
            let runtimeHours = runtime / 60
            let runtimeMins = runtime % 60
            self.runtime.text = "\(runtimeHours)h \(runtimeMins)m"
        }
        originalLanguage.text = detailedMovie?.originalLanguage
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
        releaseDate.text = String(date)
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

        if isFavorite {
            isFavorite = false
            favoriteButton.setImage(#imageLiteral(resourceName: "likeUntatted"), for: .normal)
            service.removeMovie(id: movieId)
            service.removeDetailedMovie(id: movieId)
        } else {
            isFavorite = true
            favoriteButton.setImage(#imageLiteral(resourceName: "likeTapped"), for: .normal)
            service.saveDetailedMovie(detailedMovie: detailedMovie)
            service.saveMovie(detailedMovie: detailedMovie)
        }
    }

    private func checkFavorite() {
        if service.isListedMovie(id: movieId) {
            isFavorite = true
            favoriteButton.setImage(#imageLiteral(resourceName: "likeTapped"), for: .normal)
        } else {
            isFavorite = false
            favoriteButton.setImage(#imageLiteral(resourceName: "likeUntatted"), for: .normal)
        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: castCell,
                                                      for: indexPath) as? CastCollectionViewCell
        cell?.configure(castEntry: cast[indexPath.row])
        return cell ?? UICollectionViewCell()
    }

}
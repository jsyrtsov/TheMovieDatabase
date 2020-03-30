//
//  DetailedMovieViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit
import AVKit

class DetailedMovieViewController: UIViewController {

    var movieId: Int?
    private let extractor = LinkExtractor()
    private let service = MoviesLoadingService()
    private var detailedMovie: DetailedMovie?
    private var crew: [CrewEntry] = []
    private var cast: [CastEntry] = []
    private var videos: [Video] = []
    private var isFavorite = false
    private let favoriteButton = UIButton(type: .custom)

    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
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
    @IBOutlet weak private var videosCollectionView: UICollectionView!
    @IBOutlet weak private var castCollectionView: UICollectionView!
    @IBOutlet weak private var crewCollectionView: UICollectionView!

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
        activityIndicator.startAnimating()
        titleLabel.isHidden = true
        overviewLabel.isHidden = true
        voteLabel.isHidden = true
        releaseYearLabel.isHidden = true
        taglineLabel.isHidden = true

        navigationItem.largeTitleDisplayMode = .never

        videosCollectionView.delegate = self
        videosCollectionView.dataSource = self
        videosCollectionView.register(UINib(nibName: VideoCollectionViewCell.identifier, bundle: nil),
                                      forCellWithReuseIdentifier: VideoCollectionViewCell.identifier)

        crewCollectionView.delegate = self
        crewCollectionView.dataSource = self
        crewCollectionView.register(UINib(nibName: PersonCollectionViewCell.identifier, bundle: nil),
                                    forCellWithReuseIdentifier: PersonCollectionViewCell.identifier)

        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        castCollectionView.register(UINib(nibName: PersonCollectionViewCell.identifier, bundle: nil),
                                    forCellWithReuseIdentifier: PersonCollectionViewCell.identifier)

        backdropImage.clipsToBounds = true
        backdropImage.layer.cornerRadius = 10
        configureShadows()

        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        backdropImage.addGestureRecognizer(tap)
        backdropImage.isUserInteractionEnabled = true

        favoriteButton.setImage(#imageLiteral(resourceName: "likeUntapped"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: favoriteButton)
        navigationItem.rightBarButtonItem = barButtonItem
    }

    private func loadDetails() {
        guard let movieId = movieId else {
            return
        }
        service.loadVideos(movieId: movieId) { [weak self] (result) in
            guard let result = result, let self = self else {
                return
            }
            self.videos = result
            self.videosCollectionView.reloadData()
        }

        service.loadDetails(movieId: movieId) { [weak self] (result) in
            guard let result = result, let self = self else {
                return
            }
            self.detailedMovie = result
            self.updateView()
        }
        service.loadCastAndCrew(movieId: movieId) { [weak self] (resultCast, resultCrew) in
            guard let resultCast = resultCast,
                let resultCrew = resultCrew,
                let self = self else {
                return
            }
            self.crew = resultCrew
            self.cast = resultCast
            guard let directorIndex = self.crew.firstIndex(where: { $0.job == "Director" }) else {
                return
            }
            let director = self.crew[directorIndex]
            self.crew.remove(at: directorIndex)
            self.crew.insert(director, at: 0)
            self.crew = Array(self.crew.prefix(15))
            self.cast = Array(self.cast.prefix(15))
            self.castCollectionView.reloadData()
            self.crewCollectionView.reloadData()
        }
    }

    private func updateView() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        titleLabel.isHidden = false
        overviewLabel.isHidden = false
        voteLabel.isHidden = false
        releaseYearLabel.isHidden = false
        taglineLabel.isHidden = false

        if detailedMovie?.budget == 0 {
            budget.text = "Information is coming soon"
        } else if var budget = detailedMovie?.budget {
            let budgetB = budget / 1000000000
            let budgetM = (budget / 1000000) % 1000
            let budgetT = (budget / 1000) % 1000
            budget = budget % 1000
            self.budget.text = "\(budgetB)B \(budgetM)M \(budgetT)T \(budget) $"
        }
        if detailedMovie?.revenue == 0 {
            revenue.text = "Information is coming soon"
        } else if var revenue = detailedMovie?.revenue {
            let revenueB = revenue / 1000000000
            let revenueM = (revenue / 1000000) % 1000
            let revenueT = (revenue / 1000) % 1000
            revenue = revenue % 1000
            self.revenue.text = "\(revenueB)B \(revenueM)M \(revenueT)T \(revenue) $"
        }
        if detailedMovie?.runtime == 0 {
            runtime.text = "Information is coming soon"
        } else if let runtime = detailedMovie?.runtime {
            let runtimeHours = runtime / 60
            let runtimeMins = runtime % 60
            self.runtime.text = "\(runtimeHours)h \(runtimeMins)m"
        }

        originalLanguage.text = detailedMovie?.originalLanguage
        backdropImage.loadFullPicture(path: detailedMovie?.backdropPath)
        guard let date = detailedMovie?.releaseDate?.prefix(4), let vote = detailedMovie?.voteAverage else {
            return
        }
        voteLabel.textColor = UIColor.color(forVote: vote)
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
            favoriteButton.setImage(#imageLiteral(resourceName: "likeUntapped"), for: .normal)
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
            favoriteButton.setImage(#imageLiteral(resourceName: "likeUntapped"), for: .normal)
        }
    }
}

// MARK: UICollectionViewDelegate

extension DetailedMovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == videosCollectionView {
            extractor.getUrlFromKey(key: videos[indexPath.row].key) { [weak self] (url) in
                guard let self = self else {
                    return
                }
                let player = AVPlayer(url: url)
                let vc = AVPlayerViewController()
                vc.player = player
                self.present(vc, animated: true) {
                    vc.player?.play()
                }
            }
        } else if collectionView == castCollectionView {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let personVC = storyboard.instantiateViewController(identifier: "PersonViewController")
                as? PersonViewController else {
                return
            }
            navigationController?.pushViewController(personVC, animated: true)
            personVC.personId = cast[indexPath.row].id
        } else if collectionView == crewCollectionView {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let personVC = storyboard.instantiateViewController(identifier: "PersonViewController")
                as? PersonViewController else {
                return
            }
            navigationController?.pushViewController(personVC, animated: true)
            personVC.personId = crew[indexPath.row].id
        }
    }
}

// MARK: UICollectionViewDataSource

extension DetailedMovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == crewCollectionView {
            return crew.count
        } else if collectionView == castCollectionView {
            return cast.count
        } else if collectionView == videosCollectionView {
            return videos.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == crewCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCollectionViewCell.identifier,
                                                          for: indexPath) as? PersonCollectionViewCell
            cell?.configureCrew(crewEntry: crew[indexPath.row])
            return cell ?? UICollectionViewCell()
        } else if collectionView == castCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCollectionViewCell.identifier,
                                                          for: indexPath) as? PersonCollectionViewCell
            cell?.configureCast(castEntry: cast[indexPath.row])
            return cell ?? UICollectionViewCell()
        } else if collectionView == videosCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifier,
                                                          for: indexPath) as? VideoCollectionViewCell
            cell?.configure(video: videos[indexPath.row])
            return cell ?? UICollectionViewCell()
        } else {
            return UICollectionViewCell()
        }
    }
}

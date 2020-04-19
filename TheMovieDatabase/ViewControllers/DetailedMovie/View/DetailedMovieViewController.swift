//
//  DetailedMovieViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit
import AVKit
import Locksmith

final class DetailedMovieViewController: UIViewController {

    // MARK: - Properties

    static let identifier = String(describing: DetailedMovieViewController.self)

    var movieId: Int?
    var movie: Movie?
    private let extractor = LinkExtractor()
    private let service = MoviesLoadingService()
    private let profileService = ProfileService()
    private var detailedMovie: DetailedMovie?
    private var crew: [CrewEntry] = []
    private var cast: [CastEntry] = []
    private var videos: [Video] = []
    private var isFavorite = false

    // MARK: - Subviews

    private let favoriteButton = UIButton(type: .custom)
    private let favoriteActivityIndicator = UIActivityIndicatorView(style: .gray)
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

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadDetails()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkFavorite()
    }

    // MARK: - Private Methods

    private func configureView() {
        activityIndicator.startAnimating()
        setMovieInformation(hidden: true)

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

    private func setMovieInformation(hidden isHidden: Bool) {
        titleLabel.isHidden = isHidden
        overviewLabel.isHidden = isHidden
        voteLabel.isHidden = isHidden
        releaseYearLabel.isHidden = isHidden
        taglineLabel.isHidden = isHidden
        releaseDate.isHidden = isHidden
        runtime.isHidden = isHidden
        budget.isHidden = isHidden
        revenue.isHidden = isHidden
        originalLanguage.isHidden = isHidden
    }

    private func loadDetails() {
        guard let movieId = movieId else {
            return
        }
        service.loadVideos(movieId: movieId) { [weak self] (result) in
            guard let self = self, let result = result else {
                return
            }
            self.videos = result
            self.videosCollectionView.reloadData()
        }

        service.loadDetails(movieId: movieId) { [weak self] (result) in
            guard let self = self, let result = result else {
                return
            }
            self.detailedMovie = result
            self.updateView()
        }
        service.loadCastAndCrew(movieId: movieId) { [weak self] (resultCast, resultCrew) in
            guard
                let self = self,
                let resultCast = resultCast,
                let resultCrew = resultCrew
            else {
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
            self.crew = Array(self.crew.prefix(20))
            self.cast = Array(self.cast.prefix(20))
            self.castCollectionView.reloadData()
            self.crewCollectionView.reloadData()
        }
    }

    private func updateView() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        setMovieInformation(hidden: false)

        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "en_EN")

        if detailedMovie?.budget == 0 {
            budget.text = "Information is coming soon"
        } else if let budget = detailedMovie?.budget,
            let budgetFormatted = numberFormatter.string(from: budget as NSNumber) {
            self.budget.text = String("$\(budgetFormatted)")
        }

        if detailedMovie?.revenue == 0 {
            revenue.text = "Information is coming soon"
        } else if let revenue = detailedMovie?.revenue,
            let revenueFormatted = numberFormatter.string(from: revenue as NSNumber) {
            self.revenue.text = String("$\(revenueFormatted)")
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
        guard
            let date = detailedMovie?.releaseDate?.prefix(4),
            let vote = detailedMovie?.voteAverage
        else {
            return
        }
        voteLabel.textColor = UIColor.color(forVote: vote)
        releaseYearLabel.text = String(date)
        taglineLabel.text = detailedMovie?.tagline
        overviewLabel.text = detailedMovie?.overview
        voteLabel.text = String(vote)
        titleLabel.text = detailedMovie?.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let releaseDate = detailedMovie?.releaseDate, let date = dateFormatter.date(from: releaseDate) {
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            self.releaseDate.text = dateFormatter.string(from: date)
        }
    }

    private func configureShadows() {
        baseShadowView.applyShadow(radius: 20, opacity: 0.1, offsetW: 4, offsetH: 4)
        baseShadowView.layer.cornerRadius = 20

        imageShadowView.applyShadow(radius: 10, opacity: 0.2, offsetW: 2, offsetH: 2)
        imageShadowView.layer.cornerRadius = 10
    }

    @objc
    private func imageTapped() {
        let fullPictureVC = FullPictureModuleConfigurator().configure()
        fullPictureVC.picturePath = detailedMovie?.posterPath
        navigationController?.pushViewController(fullPictureVC, animated: true)
    }

    @objc
    private func likeTapped() {
        if Locksmith.getSessionId() != nil {
            guard let movieId = movieId else {
                return
            }
            profileService.setFavoriteTo(!isFavorite, movieId: movieId) { [weak self] (result) in
                guard let self = self else {
                    return
                }
                if result {
                    if self.isFavorite {
                        self.isFavorite = false
                        self.favoriteButton.setImage(#imageLiteral(resourceName: "likeUntapped"), for: .normal)
                        self.service.removeMovie(id: movieId)
                    } else {
                        self.isFavorite = true
                        self.favoriteButton.setImage(#imageLiteral(resourceName: "likeTapped"), for: .normal)
                        self.service.saveMovie(movie: self.movie)
                    }
                } else {
                    print("not success")
                }
            }
        } else {
            if isFavorite {
                isFavorite = false
                favoriteButton.setImage(#imageLiteral(resourceName: "likeUntapped"), for: .normal)
                service.removeMovie(id: movieId)
                service.removeDetailedMovie(id: movieId)
            } else {
                isFavorite = true
                favoriteButton.setImage(#imageLiteral(resourceName: "likeTapped"), for: .normal)
                service.saveDetailedMovie(detailedMovie: detailedMovie)
                service.saveMovie(movie: movie)
            }
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

// MARK: - UICollectionViewDelegate

extension DetailedMovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == videosCollectionView {
            extractor.getUrlFromKey(key: videos[indexPath.row].key) { [weak self] (url) in
                guard let self = self else {
                    return
                }
                let player = AVPlayer(url: url)
                let avPlayerViewController = AVPlayerViewController()
                avPlayerViewController.player = player
                self.present(avPlayerViewController, animated: true) {
                    avPlayerViewController.player?.play()
                }
            }
        } else if collectionView == castCollectionView {
            let personVC = PersonModuleConfigurator().configure(personId: cast[indexPath.row].id)
            navigationController?.pushViewController(personVC, animated: true)
        } else if collectionView == crewCollectionView {
            let personVC = PersonModuleConfigurator().configure(personId: crew[indexPath.row].id)
            navigationController?.pushViewController(personVC, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource

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
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PersonCollectionViewCell.identifier,
                for: indexPath
            ) as? PersonCollectionViewCell
            cell?.configureCrew(crewEntry: crew[indexPath.row])

            return cell ?? UICollectionViewCell()
        } else if collectionView == castCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PersonCollectionViewCell.identifier,
                for: indexPath
            ) as? PersonCollectionViewCell
            cell?.configureCast(castEntry: cast[indexPath.row])

            return cell ?? UICollectionViewCell()
        } else if collectionView == videosCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: VideoCollectionViewCell.identifier,
                for: indexPath
            ) as? VideoCollectionViewCell
            cell?.configure(video: videos[indexPath.row])

            return cell ?? UICollectionViewCell()
        } else {
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DetailedMovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == castCollectionView {
            return PersonCollectionViewCell.size
        } else if collectionView == crewCollectionView {
            return PersonCollectionViewCell.size
        } else if collectionView == videosCollectionView {
            return VideoCollectionViewCell.size
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
}

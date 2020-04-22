//
//  FavoritesViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

final class FavoritesViewController: UIViewController {

    // MARK: - Properties

    private let accountId = UserDefaults.standard.accountId
    private let moviesLoadingService = MoviesLoadingService()
    private let profileService = ProfileService()
    private var movies: [Movie] = []
    private var wasShown = false

    // MARK: - Subviews

    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var blankImage: UIImageView!
    @IBOutlet weak private var blankTitle: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadFavoriteMovies()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if wasShown {
            movies = moviesLoadingService.getFavoriteMovies()
            if movies.isEmpty {
                setBlankState(hidden: false)
            } else {
                setBlankState(hidden: true)
            }
            tableView.reloadData()
        } else {
            wasShown = true
        }
    }

    // MARK: - Private Methods

    private func configureView() {
        activityIndicator.startAnimating()
        setBlankState(hidden: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MovieTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.tableFooterView = UIView()
    }

    private func loadFavoriteMovies() {
        moviesLoadingService.TESTloadFavoriteMovies(accountId: accountId) { [weak self] (movies) in
            guard
                let self = self,
                let movies = movies
            else {
                return
            }
            self.movies = movies
            self.tableView.reloadData()
            self.updateView()
        }
    }

    private func updateView() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        if movies.isEmpty {
            setBlankState(hidden: false)
        } else {
            setBlankState(hidden: true)
        }
    }

    private func setBlankState(hidden isHidden: Bool) {
        blankImage.isHidden = isHidden
        blankTitle.isHidden = isHidden
        tableView.isHidden = !isHidden
    }
}

// MARK: - TableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailedMovieVC = DetailedMovieConfigurator().configure()
        detailedMovieVC.movieId = movies[indexPath.row].id
        detailedMovieVC.movie = movies[indexPath.row]
        navigationController?.pushViewController(detailedMovieVC, animated: true)
    }
}

// MARK: - TableViewDataSource

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.identifier,
            for: indexPath
        ) as? MovieTableViewCell
        cell?.configure(movie: movies[indexPath.row])
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard let movieId = movies[indexPath.row].id else {
            return
        }
        if editingStyle == .delete {
            if AuthorizationService.getSessionId() != nil {
                profileService.setFavoriteTo(false, movieId: movieId) { [weak self] (success) in
                    guard let self = self else {
                        return
                    }
                    if success {
                        self.moviesLoadingService.removeMovie(id: movieId)
                        self.movies = self.moviesLoadingService.getFavoriteMovies()
                        if self.movies.isEmpty {
                            tableView.isHidden = true
                            self.blankImage.isHidden = false
                            self.blankTitle.isHidden = false
                        } else {
                            tableView.isHidden = false
                            self.blankImage.isHidden = true
                            self.blankTitle.isHidden = true
                        }
                        tableView.reloadData()
                    }
                }
            } else {
                moviesLoadingService.removeMovie(id: movieId)
                moviesLoadingService.removeDetailedMovie(id: movieId)
                movies = moviesLoadingService.getFavoriteMovies()
                if movies.isEmpty {
                    tableView.isHidden = true
                    blankImage.isHidden = false
                    blankTitle.isHidden = false
                } else {
                    tableView.isHidden = false
                    blankImage.isHidden = true
                    blankTitle.isHidden = true
                }
                tableView.reloadData()
            }
        }
    }
}

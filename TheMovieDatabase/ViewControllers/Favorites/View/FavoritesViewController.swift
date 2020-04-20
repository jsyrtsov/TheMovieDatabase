//
//  FavoritesViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit
import Locksmith

final class FavoritesViewController: UIViewController {

    // MARK: - Properties

    var accountId: Int?
    private let service = MoviesLoadingService()
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
        if Locksmith.getSessionId() != nil {
            loadFavoriteMovies()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if wasShown {
            movies = service.getFavoriteMovies()
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
        } else {
            wasShown = true
        }
    }

    // MARK: - Private Methods

    private func configureView() {
        activityIndicator.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MovieTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.tableFooterView = UIView()
    }

    private func loadFavoriteMovies() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        blankImage.isHidden = true
        blankTitle.isHidden = true

        guard let accountId = accountId else {
            return
        }
        let movies = service.getFavoriteMovies()
        for movie in movies {
            service.removeMovie(id: movie.id)
        }
        service.loadFavoriteMovies(accountId: accountId) { [weak self] (movies) in
            guard
                let self = self,
                let movies = movies
            else {
                return
            }
            for movie in movies {
                self.service.saveMovie(movie: movie)
            }
            self.movies = movies
            self.updateView()
            self.tableView.reloadData()
        }
    }

    private func updateView() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        if movies.isEmpty {
            tableView.isHidden = true
            blankImage.isHidden = false
            blankTitle.isHidden = false
        } else {
            tableView.isHidden = false
            blankImage.isHidden = true
            blankTitle.isHidden = true
        }
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
            service.removeMovie(id: movieId)
            service.removeDetailedMovie(id: movieId)
        }
        movies = service.getFavoriteMovies()
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

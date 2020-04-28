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
    private let moviesService = MoviesService()
    private var movies: [Movie] = []
    private var wasShown = false

    // MARK: - Subviews

    private var refreshControl = UIRefreshControl()
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
            movies = moviesService.getFavoriteMovies()
            if movies.isEmpty {
                setEmptyState(hidden: false)
            } else {
                setEmptyState(hidden: true)
            }
            tableView.reloadData()
        } else {
            wasShown = true
        }
    }

    // MARK: - Private Methods

    private func configureView() {
        activityIndicator.startAnimating()
        setEmptyState(hidden: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MovieTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.tableFooterView = UIView()

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc
    private func refreshData() {
        let service = MoviesLoadingService()
        service.loadFavoriteMovies(accountId: accountId) { [weak self] (movies) in
            guard let self = self, let movies = movies else {
                return
            }
            self.movies = movies
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

    private func loadFavoriteMovies() {
        moviesService.loadFavoriteMovies(accountId: accountId) { [weak self] (movies) in
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
        setEmptyState(hidden: !movies.isEmpty)
    }

    private func setEmptyState(hidden isHidden: Bool) {
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
        let detailedMovie = moviesService.getMovieInfo(id: movieId)
        if editingStyle == .delete {
            moviesService.setFavoriteTo(
                false,
                movie: movies[indexPath.row],
                detailedMovie: detailedMovie
            ) { [weak self] (result) in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let movies):
                    guard let movies = movies else {
                        return
                    }
                    self.movies = movies
                    self.setEmptyState(hidden: !self.movies.isEmpty)
                    tableView.reloadData()
                case .failure(let error):
                    UIAlertController.showErrorAlert(on: self, message: error.localizedDescription)
                }
            }
        }
    }
}

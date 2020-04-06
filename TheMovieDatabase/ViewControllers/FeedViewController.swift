//
//  FeedViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    // MARK: - Properties

    private lazy var service = MoviesLoadingService()
    private var movies: [Movie] = []

    // MARK: - Subviews

    private var segmentedControl: UISegmentedControl?
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var tableView: UITableView!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadMovies()
    }

    // MARK: - Private Methods

    private func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: MovieTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: MovieTableViewCell.identifier)

        let items = ["Popular", "Upcoming", "Now Playing"]
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl?.selectedSegmentIndex = 0
        tableView.tableHeaderView = segmentedControl
        segmentedControl?.addTarget(self, action: #selector(FeedViewController.indexChanged(_:)), for: .valueChanged)

    }

    @objc
    private func indexChanged(_ sender: UISegmentedControl) {
        let segmentIndex = segmentedControl?.selectedSegmentIndex
        switch segmentIndex {
        case 0:
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            movies = []
            tableView.reloadData()
            service.strategy = .popular
            loadMovies()
        case 1:
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            movies = []
            tableView.reloadData()
            service.strategy = .upcoming
            loadMovies()

        case 2:
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            movies = []
            tableView.reloadData()
            service.strategy = .nowPlaying
            loadMovies()
        default:
            break
        }
    }

    private func loadMovies() {
        service.loadMovies { [weak self] (results) in
            guard
                let movies = results,
                let self = self
            else {
                return
            }
            self.movies.append(contentsOf: movies)
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.tableView.reloadData()
        }
    }
}

// MARK: - TableViewDelegate

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailedMovieVC = DetailedMovieConfigurator().configure()
        detailedMovieVC.movieId = movies[indexPath.row].id
        navigationController?.pushViewController(detailedMovieVC, animated: true)
    }
}

// MARK: - TableViewDataSource

extension FeedViewController: UITableViewDataSource {

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

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 5, service.canLoadMore == true {
            loadMovies()
        }
    }
}

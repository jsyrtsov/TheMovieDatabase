//
//  SearchMovieViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

final class SearchMovieViewController: UIViewController {

    // MARK: - Properties

    private var service = MoviesService()
    private var query = ""
    private var movies: [Movie] = []

    // MARK: - Subviews

    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var tableView: UITableView!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: - Private Methods

    private func configureView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        activityIndicator.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: MovieTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: MovieTableViewCell.identifier)
        let search = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = search
        search.searchBar.delegate = self
    }

    private func addMovies(query: String) {
        service.loadMovies { [weak self] (results) in
            guard let self = self, let movies = results else {
                return
            }
            self.movies.append(contentsOf: movies)
            self.tableView.reloadData()
        }
    }

    private func loadMovies(query: String) {
        service.strategy = .search(query: query)
        service.loadMovies { [weak self] (results) in
            guard
                let movies = results,
                let self = self
            else {
                return
            }
            self.movies = movies
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
}

// MARK: - UITableViewDataSource

extension SearchMovieViewController: UITableViewDataSource {

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
            addMovies(query: query)
        }
    }
}

// MARK: - UITableViewDelegate

extension SearchMovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailedMovieVC = DetailedMovieConfigurator().configure()
        detailedMovieVC.movieId = movies[indexPath.row].id
        detailedMovieVC.movie = movies[indexPath.row]
        navigationController?.pushViewController(detailedMovieVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension SearchMovieViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        guard let searchQuery = searchBar.text else {
            return
        }
        query = searchQuery
        loadMovies(query: query)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        movies = []
        tableView.reloadData()
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}

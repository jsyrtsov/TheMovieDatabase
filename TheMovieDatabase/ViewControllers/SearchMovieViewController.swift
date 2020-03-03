//
//  SearchViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class SearchMovieViewController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!

    private lazy var service = MoviesLoadingService(strategy: .search(query: ""))
    private var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "moviesCell")
        let search = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = search
        search.searchBar.delegate = self
    }

    private func addMovies() {
        service.loadMovies { (results) in
            guard let movies = results else {
                return
            }
            self.movies.append(contentsOf: movies)
            self.tableView.reloadData()
        }
    }

    private func loadMovies() {
        service.loadMovies { (results) in
            guard let movies = results else {
                return
            }
            self.movies = movies
            self.tableView.reloadData()
        }
    }
}

// MARK: UITableViewDataSource
extension SearchMovieViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 129
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell", for: indexPath) as? MovieTableViewCell
        cell?.configure(withMovie: movies[indexPath.row])
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 5, service.canLoadMore == true {
            addMovies()
        }
    }
}

// MARK: UITableViewDelegate
extension SearchMovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: UISearchBarDelegate
extension SearchMovieViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchQuery = searchBar.text else {
            return
        }
        self.service = MoviesLoadingService(strategy: .search(query: searchQuery))
        loadMovies()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        movies = []
        tableView.reloadData()
    }
}

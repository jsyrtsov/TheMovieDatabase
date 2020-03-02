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

    private let manager = SearchManager()
    private var searchWords = ""
    private let manager2 = MovieLoadingManager(strategy: .search, query: "mySearch")
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

    private func loadMovies() {
        manager.loadMovies(withSearchWords: searchWords) { results in
            guard let movies = results else {
                return
            }
            if self.manager.currentPageNum == 1 {
                self.movies = movies
            } else {
                self.movies.append(contentsOf: movies)
            }
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
        if indexPath.row == movies.count - 5 {
            if manager.currentPageNum < manager.totalPages {
                loadMovies()
            }
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
        if let searchQuery = searchBar.text {
            searchWords = searchQuery.replacingOccurrences(of: " ", with: "%20")
        }
        manager.currentPageNum = 1
        loadMovies()
    }
}

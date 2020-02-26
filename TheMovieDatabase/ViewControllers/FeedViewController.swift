//
//  FeedViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!

    let manager = MoviesService()

    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadMovies()
    }

    private func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    private func loadMovies() {
        manager.loadMovies {loadMoviesResponse in
            guard let results = loadMoviesResponse else {
                return
            }
            self.movies.append(contentsOf: results)
            self.tableView.reloadData()
        }
    }
}

// MARK: TableViewDelegate
extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: TableViewDataSource
extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell
        cell?.configure(withMovie: movies[indexPath.row])
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 5 {
            loadMovies()
        }
    }
}

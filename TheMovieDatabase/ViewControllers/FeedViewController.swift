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

        let items = ["Popular", "Upcoming", "Now Playing"]
        let segmentedControll = UISegmentedControl(items: items)
        tableView.tableHeaderView = segmentedControll

    }

    private func loadMovies() {

        let manager = NetworkService()

        let currentPageUrl: String = """
        https://api.themoviedb.org/3/movie/popular?api_key=43c76333cdbd2a5869d68050de560ceb&language=en-US&page=1
        """

        manager.loadMovies(withUrl: currentPageUrl) { LoadMoviesResponse in
            guard let results = LoadMoviesResponse.results else {
                return
            }
            self.movies = results
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
        cell?.configureCell(withMovie: movies[indexPath.row])
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 5 {

        }
    }

}

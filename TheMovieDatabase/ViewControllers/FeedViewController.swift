//
//  FeedViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet weak private var segmentedControl: UISegmentedControl!
    @IBOutlet weak private var tableView: UITableView!

    private var service = MoviesLoadingService(strategy: .popular)

    private var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadMovies()
    }

    private func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "moviesCell")
    }

    @IBAction private func segmentChanged(_ sender: Any) {
        let segmentIndex = segmentedControl.selectedSegmentIndex
        switch segmentIndex {
        case 0:
            movies = []
            service = MoviesLoadingService(strategy: .popular)
            loadMovies()
        case 1:
            movies = []
            service = MoviesLoadingService(strategy: .upcoming)
            loadMovies()
        case 2:
            movies = []
            service = MoviesLoadingService(strategy: .nowPlaying)
            loadMovies()
        default:
            break
        }
    }

    private func loadMovies() {
        service.loadMovies { (results) in
            guard let movies = results else {
                return
            }
            self.movies.append(contentsOf: movies)
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
            loadMovies()
        }
    }
}

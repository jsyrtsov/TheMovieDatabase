//
//  FeedViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    private var segmentedControl: UISegmentedControl?

    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
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
            service = MoviesLoadingService(strategy: .popular)
            loadMovies()
        case 1:
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            movies = []
            tableView.reloadData()
            service = MoviesLoadingService(strategy: .upcoming)
            loadMovies()

        case 2:
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            movies = []
            tableView.reloadData()
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
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
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

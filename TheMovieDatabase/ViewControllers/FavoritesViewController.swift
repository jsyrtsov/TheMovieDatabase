//
//  FavoritesViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var blankImage: UIImageView!
    @IBOutlet weak private var blankTitle: UILabel!

    private let service = MoviesLoadingService()
    private var movies: [Movie] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NewMovieTableViewCell", bundle: nil), forCellReuseIdentifier: "myCell")
        tableView.tableFooterView = UIView()
    }
}

// MARK: TableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let newDetailedVC = storyboard.instantiateViewController(withIdentifier: "DetailedMovieViewController")
            as? NewDetailedMovieViewController else {
            return
        }
        navigationController?.pushViewController(newDetailedVC, animated: true)
        newDetailedVC.movieId = movies[indexPath.row].id
    }
}

// MARK: TableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? NewMovieTableViewCell
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

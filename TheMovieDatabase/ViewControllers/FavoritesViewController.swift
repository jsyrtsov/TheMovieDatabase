//
//  FavoritesViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit
import RealmSwift

class FavoritesViewController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var blankImage: UIImageView!
    @IBOutlet weak private var blankTitle: UILabel!

    //private var movieObjects: Results<MovieObject>?
    private let storageService = StorageService()
    private var movies: [Movie] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        movies = storageService.getFavMovies()
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
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "moviesCell")
        tableView.tableFooterView = UIView()
    }
}

// MARK: TableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailedVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController")
            as? DetailedMovieViewController  else {
            return
        }
        navigationController?.pushViewController(detailedVC, animated: true)
        detailedVC.movieId = movies[indexPath.row].id
    }
}

// MARK: TableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell", for: indexPath) as? MovieTableViewCell
        cell?.configure(withMovie: movies[indexPath.row])
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 129
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard let movieId = movies[indexPath.row].id else {
            return
        }
        if editingStyle == .delete {
            do {
                let realm = try Realm()
                let movieObjects = realm.objects(MovieObject.self)
                for element in movieObjects {
                    if movieId == element.id.value {
                        try realm.write {
                            realm.delete(element)
                        }
                    }
                }
                let detailedMovieObjects = realm.objects(DetailedMovieObject.self)
                for element in detailedMovieObjects {
                    if movieId == element.id.value {
                        try realm.write {
                            realm.delete(element)
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
        movies = storageService.getFavMovies()
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

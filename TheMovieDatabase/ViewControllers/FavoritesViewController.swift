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

    private var movieObjects: Results<MovieObject>?
    private var isEmpty: Bool = true

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let realm = try? Realm()
        movieObjects = realm?.objects(MovieObject.self)
        if movieObjects?.isEmpty == true {
            isEmpty = true
        } else {
            isEmpty = false
        }
        switch isEmpty {
        case true:
            tableView.isHidden = true
            blankImage.isHidden = false
            blankTitle.isHidden = false
        case false:
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
        detailedVC.movieId = movieObjects?[indexPath.row].id.value
    }
}

// MARK: TableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let num = movieObjects?.count else {
            return 0
        }
        return num
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell", for: indexPath) as? MovieTableViewCell
        guard let movieObjects = movieObjects else {
            return UITableViewCell()
        }
        cell?.configure(withObject: movieObjects[indexPath.row])
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 129
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        var movieId: Int = 0
        do {
            let realm = try Realm()
            let movieObjects = realm.objects(MovieObject.self)
            guard let movieIdNotNil = movieObjects[indexPath.row].id.value else {
                return
            }
            movieId = movieIdNotNil
        } catch {
            print(error)
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
            tableView.reloadData()
        }
    }
}

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

    var movieObjects: Results<MovieObject>?
    var movies: [Movie] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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

        let realm = try? Realm()
        movieObjects = realm?.objects(MovieObject.self)
        if movieObjects?.isEmpty == true {
            blankImage.isHidden = false
            blankTitle.isHidden = false
        } else {
            blankImage.isHidden = true
            blankTitle.isHidden = true
        }
    }
}

// MARK: TableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
}

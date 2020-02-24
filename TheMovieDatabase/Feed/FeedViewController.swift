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

    override func viewDidLoad() {

        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        let items = ["Popular", "Upcoming", "Now Playing"]
        let segmentedController = UISegmentedControl(items: items)
        navigationItem.titleView = segmentedController

    }

}

extension FeedViewController: UITableViewDelegate {

}
extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell
        return cell ?? UITableViewCell()
    }

}

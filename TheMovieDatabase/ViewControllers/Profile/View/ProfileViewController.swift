//
//  ProfileViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/17/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - Properties
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: - IBActions

    @IBAction private func loginAction(_ sender: Any) {
        appDelegate?.initializeAuthView()
    }

    // MARK: - Private Methods

    private func configureView() {
        navigationController?.title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

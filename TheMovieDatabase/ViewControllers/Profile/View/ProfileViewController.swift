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

    // MARK: - Subviews

    @IBOutlet weak private var loginButton: UIButton!

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
        self.title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        loginButton.tintColor = .systemBlue
        if UserDefaults.standard.isLogged {
            loginButton.setTitle("LOG OUT", for: .normal)
            loginButton.tintColor = .red
        } else {
            loginButton.setTitle("LOG IN", for: .normal)
        }
    }
}

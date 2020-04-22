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
    private let profileService = ProfileService()
    private let moviesLoadingService = MoviesLoadingService()
    private let authorizationService = AuthorizationService()
    private var account: Account?

    // MARK: - Subviews

    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var loginButton: UIButton!
    @IBOutlet weak private var helloLabel: UILabel!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        if authorizationService.getSessionId() != nil {
            getAccountDetails()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }

    // MARK: - IBActions

    @IBAction private func showFavoriteMovies(_ sender: Any) {
        let favoritesVC = FavoritesConfigurator().configure()
        navigationController?.pushViewController(favoritesVC, animated: true)
    }

    @IBAction private func logInOrOutAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let movies = moviesLoadingService.getFavoriteMovies()
        if authorizationService.getSessionId() != nil {
            authorizationService.logout { (result) in
                //MAYBE DO SOMETHING HERE, MAYBE DO NOT
            }
            for movie in movies {
                moviesLoadingService.removeMovie(id: movie.id)
            }
            appDelegate?.initializeAuthView()
        } else {
            for movie in movies {
                moviesLoadingService.removeMovie(id: movie.id)
                moviesLoadingService.removeDetailedMovie(id: movie.id)
            }
            UserDefaults.standard.loginViewWasShown = false
            appDelegate?.initializeAuthView()
        }
    }

    // MARK: - Private Methods

    private func getAccountDetails() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        setAccountDetails(hidden: true)
        profileService.getAccountDetails { [weak self] (account) in
            guard
                let self = self,
                let account = account
            else {
                return
            }
            self.account = account
            self.updateView()
        }
    }

    private func configureView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        loginButton.tintColor = .systemBlue
        self.title = UserDefaults.standard.username
        helloLabel.text = "hello, \(UserDefaults.standard.username)"
        if authorizationService.getSessionId() != nil {
            loginButton.setTitle("LOG OUT", for: .normal)
            loginButton.tintColor = .red
        } else {
            loginButton.setTitle("LOG IN", for: .normal)
        }
    }

    private func updateView() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        setAccountDetails(hidden: false)
    }

    private func setAccountDetails(hidden isHidden: Bool) {
        helloLabel.isHidden = isHidden
    }
}

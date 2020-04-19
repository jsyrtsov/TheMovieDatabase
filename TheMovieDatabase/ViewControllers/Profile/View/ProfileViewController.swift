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
    private let service = ProfileService()
    private let authService = AuthorizationService()
    private var account: Account?

    // MARK: - Subviews

    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var loginButton: UIButton!
    @IBOutlet weak private var helloLabel: UILabel!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        if authService.getSessionId() != nil {
            getAccountDetails()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }

    // MARK: - IBActions

    @IBAction private func showFavoriteMovies(_ sender: Any) {
        let favoritesVC = FavoritesConfigurator().configure()
        favoritesVC.accountId = UserDefaults.standard.accountId
        navigationController?.pushViewController(favoritesVC, animated: true)
    }

    @IBAction private func logInOrOutAction(_ sender: Any) {
        if authService.getSessionId() != nil {
            authService.logout { (result) in
                //MAYBE DO SOMETHING HERE, MAYBE DO NOT
            }
            appDelegate?.initializeAuthView()
        } else {
            UserDefaults.standard.loginViewWasShown = false
            appDelegate?.initializeAuthView()
        }
    }

    // MARK: - Private Methods

    private func getAccountDetails() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        setAccountDetails(hidden: true)
        service.getAccountDetails { [weak self] (account) in
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
        if authService.getSessionId() != nil {
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

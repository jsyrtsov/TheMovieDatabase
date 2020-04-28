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
        getAccountDetails()
    }

    // MARK: - IBActions

    @IBAction private func showFavoriteMovies(_ sender: Any) {
        let favoritesVC = FavoritesConfigurator().configure()
        navigationController?.pushViewController(favoritesVC, animated: true)
    }

    @IBAction private func logoutAction(_ sender: Any) {
        UserDefaults.standard.loginViewWasShown = false
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        authorizationService.logout { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(()):
                appDelegate?.initializeAuthView()
            case .failure(let error):
                UIAlertController.showErrorAlert(on: self, message: error.localizedDescription)
            }
        }
    }

    // MARK: - Private Methods

    private func getAccountDetails() {
        profileService.getAccountDetails { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let account):
                guard let account = account else {
                    return
                }
                self.account = account
                self.updateView()
            case .failure(let error):
                UIAlertController.showErrorAlert(on: self, message: error.localizedDescription)
            }
        }
    }

    private func configureView() {
        activityIndicator.startAnimating()
        setAccountDetails(hidden: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        loginButton.tintColor = .systemBlue
        self.title = UserDefaults.standard.username
        helloLabel.text = "Hello, \(UserDefaults.standard.username)"
        if UserDefaults.standard.username != "Guest" {
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

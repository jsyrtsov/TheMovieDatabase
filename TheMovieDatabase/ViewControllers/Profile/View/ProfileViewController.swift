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
        if UserDefaults.standard.isLogged {
            getAccountDetails()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            self.title = "Profile"
            helloLabel.text = "hello, guest"
        }
    }

    // MARK: - IBActions

    @IBAction private func loginAction(_ sender: Any) {
        if UserDefaults.standard.isLogged {
            authService.logout { (result) in
                print(result)
            }
//            UserDefaults.standard.wantAsGuest = true
            appDelegate?.initializeAuthView()
        } else {
//            UserDefaults.standard.wantAsGuest = false
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
        if UserDefaults.standard.isLogged {
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
        guard let username = account?.username else {
            return
        }
        self.title = username
        helloLabel.text = "hello, \(username)"
    }

    private func setAccountDetails(hidden isHidden: Bool) {
        helloLabel.isHidden = isHidden
    }
}

//
//  AuthorizationViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/17/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

final class AuthorizationViewController: UIViewController {

    // MARK: - Properties

    private let service = AuthorizationService()
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate

    // MARK: - Subviews

    @IBOutlet weak private var loginTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions

    @IBAction private func signInAction(_ sender: Any) {
        guard
            let login = loginTextField.text,
            let password = passwordTextField.text
        else {
            return
        }
        service.login(login: login, password: password) { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success( _):
                self.appDelegate?.initializeRootView()
            case .failure(let error):
                UIAlertController.showAlert(on: self, message: error.localizedDescription)
            }
        }
    }

    @IBAction private func tryAsGuestAction(_ sender: Any) {
        UserDefaults.standard.loginViewWasShown = true
        appDelegate?.initializeRootView()
    }
}

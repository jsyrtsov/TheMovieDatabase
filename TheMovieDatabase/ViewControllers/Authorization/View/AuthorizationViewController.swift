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
        service.login(login: login, password: password)
    }

    @IBAction private func tryAsGuestAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        UserDefaults.standard.loginViewWasShown = true
        appDelegate?.initializeRootView()
    }
}

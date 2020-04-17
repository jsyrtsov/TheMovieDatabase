//
//  AuthorizationViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 4/17/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit
import Locksmith

final class AuthorizationViewController: UIViewController {

    // MARK: - Properties

    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private let service = ProfileService()

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
        service.authorizeUser(login: login, password: password)
    }

    @IBAction private func tryAsGuestAction(_ sender: Any) {
        UserDefaults.standard.wantAsGuest = true
        appDelegate?.initializeRootView()
    }
}

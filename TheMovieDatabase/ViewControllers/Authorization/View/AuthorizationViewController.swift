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

    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var baseShadowView: UIView!
    @IBOutlet weak private var loginTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
                UserDefaults.standard.loginViewWasShown = true
            case .failure(let error):
                UIAlertController.showAlert(on: self, message: error.localizedDescription)
            }
        }
    }

    @IBAction private func tryAsGuestAction(_ sender: Any) {
        UserDefaults.standard.loginViewWasShown = true
        appDelegate?.initializeRootView()
    }

    // MARK: - Private Methods

    private func configureUI() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        baseShadowView.layer.cornerRadius = 15
        baseShadowView.applyShadow(radius: 10, opacity: 0.06, offsetW: 5, offsetH: 5)
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo
        guard var keyboardFrame = (userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

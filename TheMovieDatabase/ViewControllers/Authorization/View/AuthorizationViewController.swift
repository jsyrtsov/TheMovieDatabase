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
        hideKeyboardWhenTappedAround()
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

    private func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo
        guard var keyboardFrame = (userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardFrame = view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
        scrollView.setContentOffset(CGPoint(x: 0,
                                            y: scrollView.contentSize.height -
                                                scrollView.bounds.size.height +
                                                scrollView.contentInset.bottom),
                                    animated: true)
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

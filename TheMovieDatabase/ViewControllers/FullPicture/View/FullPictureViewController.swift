//
//  FullPictureViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 3/4/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

class FullPictureViewController: UIViewController {

    // MARK: - Properties

    var picturePath: String?

    // MARK: - Subviews

    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var imageView: UIImageView!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadPic()
    }

    // MARK: - Private Methods

    private func configureView() {
        activityIndicator.startAnimating()
    }

    private func loadPic() {
        imageView.loadFullPicture(path: picturePath)
    }
}

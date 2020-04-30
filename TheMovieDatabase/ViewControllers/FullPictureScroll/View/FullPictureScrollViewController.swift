//
//  FullPictureScrollViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 5/1/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

final class FullPictureScrollViewController: UIViewController {

    // MARK: - Properties

    var imagesArray: [String?] = []

    // MARK: - Subviews

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return scroll
    }()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Private Methods

    private func configureUI() {
        view.addSubview(scrollView)
        setupImages(imagesArray)
    }

    private func setupImages(_ images: [String?]) {
        for i in 0..<images.count {
            let imageView = UIImageView()
            imageView.loadFullPicture(path: images[i])
            let xPosition = UIScreen.main.bounds.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            imageView.contentMode = .scaleAspectFit

            self.scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            self.scrollView.addSubview(imageView)
            self.scrollView.delegate = self
        }
    }
}

extension FullPictureScrollViewController: UIScrollViewDelegate {

}

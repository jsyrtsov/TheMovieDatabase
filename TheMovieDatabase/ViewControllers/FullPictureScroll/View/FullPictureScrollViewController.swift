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
    var currentImage = 0

    // MARK: - Subviews

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        let window = UIApplication.shared.keyWindow
        if let topPadding = window?.safeAreaInsets.top, let bottomPadding = window?.safeAreaInsets.bottom {
            scroll.frame = CGRect(x: 0,
                                  y: 0,
                                  width: UIScreen.main.bounds.width,
                                  height: UIScreen.main.bounds.height - topPadding - bottomPadding)
        }

        return scroll
    }()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Private Methods

    private func configureUI() {
        title = "\(currentImage + 1) / \(imagesArray.count)"
        view.backgroundColor = .white
        setupImages(imagesArray, currentImage)
        view.addSubview(scrollView)
    }

    private func setupImages(_ images: [String?], _ currentImage: Int) {
        for i in 0..<images.count {
            let imageView = UIImageView()
            imageView.loadFullPicture(path: images[i])
            let xPosition = UIScreen.main.bounds.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition,
                                     y: 0,
                                     width: scrollView.frame.width,
                                     height: scrollView.frame.height)
            imageView.contentMode = .scaleAspectFit

            self.scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            self.scrollView.addSubview(imageView)
            self.scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width * CGFloat(currentImage),
                                                     y: CGFloat(0)), animated: false)
            self.scrollView.delegate = self
        }
    }
}

// MARK: - UIScrollViewDelegate

extension FullPictureScrollViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width) + 1
        print("\(index)/\(imagesArray.count)")
        self.title = "\(index) / \(imagesArray.count)"
    }
}

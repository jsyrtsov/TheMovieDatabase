//
//  ImageViewerViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 5/1/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

final class ImageViewerViewController: UIViewController {

    // MARK: - Properties

    var imagesArray: [String?] = []
    var currentImage = 0

    private var imageViewsArray: [UIImageView] = []
    private var state: State = .normal {
        didSet {
            switch state {
            case .normal:
                view.backgroundColor = .white
                navigationController?.isNavigationBarHidden = false
            case .fullScreen:
                view.backgroundColor = .black
                navigationController?.isNavigationBarHidden = true
            }
        }
    }

    // MARK: - Subviews

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Private Methods

    private func configureUI() {

        view.backgroundColor = .white

        scrollView.delegate = self
        navigationController?.view.backgroundColor = .white
        title = "\(currentImage + 1) / \(imagesArray.count)"

        let window = UIApplication.shared.keyWindow
        if
            let topPadding = window?.safeAreaInsets.top,
            let bottomPadding = window?.safeAreaInsets.bottom {
            scrollView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: UIScreen.main.bounds.width,
                                      height: UIScreen.main.bounds.height - topPadding - bottomPadding)
        }

        setupImages(imagesArray, currentImage)
        view.addSubview(scrollView)
    }

    private func setupImages(_ images: [String?], _ currentImage: Int) {
        for i in 0..<images.count {
            let xPosition = UIScreen.main.bounds.width * CGFloat(i)

            let imageView = UIImageView()
            imageView.clipsToBounds = true
            imageView.layer.masksToBounds = true
            imageView.frame = CGRect(x: xPosition,
                                     y: 0,
                                     width: UIScreen.main.bounds.width,
                                     height: UIScreen.main.bounds.height)
            imageView.isUserInteractionEnabled = true
            imageView.contentMode = .scaleAspectFit

            let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            imageView.addGestureRecognizer(tap)

            imageView.loadFullPicture(path: images[i])

            self.scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            self.scrollView.addSubview(imageView)
            self.scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width * CGFloat(currentImage),
                                                     y: CGFloat(0)), animated: false)
        }
    }

    @objc
    private func imageTapped() {
        if state == .normal {
            state = .fullScreen
        } else {
            state = .normal
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ImageViewerViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width) + 1
        self.title = "\(index) / \(imagesArray.count)"
    }
}

// MARK: - Private Enums

private enum State {
    case normal
    case fullScreen
}

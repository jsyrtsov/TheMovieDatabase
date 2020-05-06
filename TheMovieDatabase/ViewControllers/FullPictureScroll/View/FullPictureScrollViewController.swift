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

    private var state: State = .white {
        didSet {
            switch state {
            case .white:
                view.backgroundColor = .white
                navigationController?.isNavigationBarHidden = false
            case .black:
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
        return scrollView
    }()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Private Methods

    private func configureUI() {
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        let window = UIApplication.shared.keyWindow

        navigationController?.view.backgroundColor = .white
        title = "\(currentImage + 1) / \(imagesArray.count)"

        if
            let topPadding = window?.safeAreaInsets.top,
            let bottomPadding = window?.safeAreaInsets.bottom {
            scrollView.frame = CGRect(x: 0,
                                      y: topPadding,
                                      width: UIScreen.main.bounds.width,
                                      height: UIScreen.main.bounds.height - topPadding - bottomPadding)
        }
        view.backgroundColor = .white

        setupImages(imagesArray, currentImage)
        view.addSubview(scrollView)
    }

    private func setupImages(_ images: [String?], _ currentImage: Int) {
        for i in 0..<images.count {
            let imageView = UIImageView()

            let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            imageView.addGestureRecognizer(tap)
            imageView.isUserInteractionEnabled = true

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
        }
    }

    @objc
    private func imageTapped() {
        if state == .white {
            state = .black
        } else {
            state = .white
        }
    }
}

// MARK: - UIScrollViewDelegate

extension FullPictureScrollViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width) + 1
        self.title = "\(index) / \(imagesArray.count)"
    }
}

// MARK: - Private Enums

private enum State {
    case white
    case black
}

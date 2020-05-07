//
//  UIViewController.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 5/7/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

extension UIViewController {
    func scrollToTop() {
        func scrollToTop(view: UIView?) {
            guard let view = view else {
                return
            }
            switch view {
            case let scrollView as UIScrollView:
                if scrollView.scrollsToTop {
                    scrollView.setContentOffset(CGPoint(x: 0, y: -140), animated: true)
                    return
                }
            default:
                break
            }
            for subView in view.subviews {
                scrollToTop(view: subView)
            }
        }
        scrollToTop(view: self.view)
    }
}

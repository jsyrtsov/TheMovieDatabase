//
//  AppDelegate.swift
//  TheMovieDatabase
//
//  Created by Evgeny Syrtsov on 2/21/20.
//  Copyright © 2020 Evgeny Syrtsov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        initializeRootView()
        return true
    }

    private func initializeRootView() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        let tabBarController = UITabBarController()
        guard
            let feedViewController = UIStoryboard(
                name: String(describing: FeedViewController.self), bundle: Bundle.main
            ).instantiateInitialViewController() as? FeedViewController
        else {
            fatalError(
                """
                Can't load FeedViewController from storyboard, check that controller is initial view controller
                """
            )
        }
        guard
            let favoritesViewController = UIStoryboard(
                name: String(describing: FavoritesViewController.self), bundle: Bundle.main
            ).instantiateInitialViewController() as? FavoritesViewController
        else {
            fatalError(
                """
                Can't load FavoritesViewController from storyboard, check that controller is initial view controller
                """
            )
        }
        guard
            let searchMovieViewController = UIStoryboard(
                name: String(describing: SearchMovieViewController.self), bundle: Bundle.main
            ).instantiateInitialViewController() as? SearchMovieViewController
        else {
            fatalError(
                """
                Can't load SearchMovieViewControllerb from storyboard, check that controller is initial view controller
                """
            )
        }
        tabBarController.setViewControllers([
            UINavigationController(rootViewController: feedViewController),
            UINavigationController(rootViewController: favoritesViewController),
            UINavigationController(rootViewController: searchMovieViewController)
        ], animated: true)

        tabBarController.tabBar.items?[0].title = "Feed"
        tabBarController.tabBar.items?[0].image = #imageLiteral(resourceName: "iconFeed")
        tabBarController.tabBar.items?[1].title = "Favorites"
        tabBarController.tabBar.items?[1].image = #imageLiteral(resourceName: "iconFavorite")
        tabBarController.tabBar.items?[2].title = "Search"
        tabBarController.tabBar.items?[2].image = #imageLiteral(resourceName: "iconSearch")

        window?.rootViewController = tabBarController
    }
}

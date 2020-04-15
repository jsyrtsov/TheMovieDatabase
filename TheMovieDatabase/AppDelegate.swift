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
        let feedViewController = FeedConfigurator().configure()
        let favoritesViewController = FavoritesConfigurator().configure()
        let searchMovieViewController = SearchMovieConfigurator().configure()

        feedViewController.tabBarItem = UITabBarItem(title: "Feed", image: #imageLiteral(resourceName: "iconFeed"), tag: 0)
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: #imageLiteral(resourceName: "iconFavorite"), tag: 0)
        searchMovieViewController.tabBarItem = UITabBarItem(title: "Search", image: #imageLiteral(resourceName: "iconSearch"), tag: 0)

        tabBarController.setViewControllers([
            UINavigationController(rootViewController: feedViewController),
            UINavigationController(rootViewController: favoritesViewController),
            UINavigationController(rootViewController: searchMovieViewController)
        ], animated: true)

        window?.rootViewController = tabBarController
    }
}

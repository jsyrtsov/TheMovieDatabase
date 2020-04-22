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
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        if UserDefaults.standard.loginViewWasShown {
            initializeRootView()
        } else {
            UserDefaults.standard.loginViewWasShown = true
            initializeAuthView()
        }
        return true
    }

    func initializeAuthView() {
        let authorizationVC = AuthorizationConfigurator().configure()
        window?.rootViewController = authorizationVC
    }

    func initializeRootView() {
        let tabBarController = UITabBarController()
        let feedViewController = FeedConfigurator().configure()
        let favoritesViewController = FavoritesConfigurator().configure()
        let searchMovieViewController = SearchMovieConfigurator().configure()
        let profileViewController = ProfileConfigurator().configure()

        feedViewController.tabBarItem = UITabBarItem(title: "Feed", image: #imageLiteral(resourceName: "iconFeed"), tag: 0)
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: #imageLiteral(resourceName: "iconFavorite"), tag: 0)
        searchMovieViewController.tabBarItem = UITabBarItem(title: "Search", image: #imageLiteral(resourceName: "search"), tag: 0)
        profileViewController.tabBarItem = UITabBarItem(title: UserDefaults.standard.username, image: #imageLiteral(resourceName: "iconProfile"), tag: 0)

        tabBarController.setViewControllers([
            UINavigationController(rootViewController: feedViewController),
            UINavigationController(rootViewController: favoritesViewController),
            UINavigationController(rootViewController: searchMovieViewController),
            UINavigationController(rootViewController: profileViewController)
        ], animated: true)

        window?.rootViewController = tabBarController
    }
}

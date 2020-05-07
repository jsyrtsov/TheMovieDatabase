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
            initializeAuthView()
        }
        return true
    }

    func initializeAuthView() {
        let authorizationVC = AuthorizationConfigurator().configure()
        window?.rootViewController = authorizationVC
    }

    func initializeRootView() {
        UserDefaults.standard.loginViewWasShown = true

        let tabBarController = UITabBarController()
        tabBarController.delegate = self
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

// MARK: - UITabBarControllerDelegate

extension AppDelegate: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        let vc = viewController as? UINavigationController
        let array = vc?.viewControllers
        print(array?.count)
        print("will be index is \(tabBarController.selectedIndex)")
    }
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        print("previous index is \(tabBarController.selectedIndex)")
        let vc = viewController as? UINavigationController
        let array = vc?.viewControllers
        print(array?.count)
        return true
    }
//    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool
//    {
//        guard let tabBarControllers = tabBarController.viewControllers
//        else
//        {
//            // TabBar have no configured controllers
//            return true
//        }
//
//        if let newIndex = tabBarControllers.indexOf(viewController) where newIndex == tabBarController.selectedIndex
//        {
//            // Index won't change so we can scroll
//
//            guard let tableViewController = viewController as? UITableViewController // Or any other condition
//            else
//            {
//                // We are not in UITableViewController
//                return true
//            }
//
//            tableViewController.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
//        }
//
//        return true
//    }
}

//
//  AppDelegate.swift
//  NewsWebsite
//
//  Created by Artem Manakov on 23.01.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .systemBackground
        let webVC = WebViewController()
        let navigationController = UINavigationController(rootViewController: webVC)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()

        return true
    }

}


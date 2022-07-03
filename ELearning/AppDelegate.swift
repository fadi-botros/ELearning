//
//  AppDelegate.swift
//  ELearning
//
//  Created by fadi on 22/06/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        ScreenManagerImpl(window: self.window!, repositoryFactory: RepositoryFactoryImpl()).showLoginScreen()
        return true
    }

}


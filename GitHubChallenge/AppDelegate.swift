//
//  AppDelegate.swift
//  GitHubChallenge
//
//  Created by namik kaya on 8.05.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAppUI()
        return true
    }

}

extension AppDelegate {
    private func setupAppUI() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            window!.overrideUserInterfaceStyle = .light
        }
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
}

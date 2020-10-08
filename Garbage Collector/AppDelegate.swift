//
//  AppDelegate.swift
//  Garbage Collector
//
//  Created by Viktor on 07.10.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        launchTheGame()
        return true
    }
    
    
    func launchTheGame() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let gameVC = GameViewController()
        self.window?.rootViewController = gameVC
    }

}

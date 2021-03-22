//
//  AppDelegate.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/3/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow.init(frame: UIScreen.main.bounds)
        let vc = RootViewController()
        let nav = UINavigationController.init(rootViewController: vc)
        nav.view.backgroundColor = .white
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }


}


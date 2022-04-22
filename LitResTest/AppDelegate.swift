//
//  AppDelegate.swift
//  LitResTest
//
//  Created by Tatty on 20.04.2022.
//
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let controller = ControllersFactory.initListViewController()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    
        return true
    }
}

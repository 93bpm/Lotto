//
//  AppDelegate.swift
//  Lotto
//
//  Created by Qtec on 2022/11/28.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        setupNavigationBar()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let root = MainTabBarController()
        window?.rootViewController = root
        
        return true
    }
}

extension AppDelegate {
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = nil
        
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().tintColor = .textColor
    }
}

extension AppDelegate {
    
    static var keyWindow: UIWindow? {
        if #available(iOS 15, *) {
            return UIApplication.shared.connectedScenes.compactMap({$0 as? UIWindowScene}).first?.windows.first {$0.isKeyWindow}
        } else {
            return UIApplication.shared.windows.first {$0.isKeyWindow}
        }
    }
    
    static var statusBarHeight: CGFloat {
        if #available(iOS 13, *) {
            return AppDelegate.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
}

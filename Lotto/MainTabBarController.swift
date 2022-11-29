//
//  MainTabBarController.swift
//  Lotto
//
//  Created by Qtec on 2022/11/28.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupTabBarControls()
        
    }
    
    private func setupTabBar() {
        delegate = self
        
        tabBar.isTranslucent = false
        
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .tabBarColor
            appearance.shadowColor = nil
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.barTintColor = .tabBarColor
        }
        
        let attribute: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.5)
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(attribute, for: .normal)
    }
    
    private func setupTabBarControls() {
        let num = MyNumberController()
        let numnc = UINavigationController(rootViewController: num)
        numnc.tabBarItem.tag = 0
        numnc.tabBarItem.title = "내번호"
        numnc.tabBarItem.image = UIImage(named: "tab_numbers")
        
        let home = HomeController()
        let homenc = UINavigationController(rootViewController: home)
        homenc.tabBarItem.tag = 1
        homenc.tabBarItem.title = "홈"
        homenc.tabBarItem.image = UIImage(named: "tab_home")
        
        let setting = SettingCollection()
        let settingnc = UINavigationController(rootViewController: setting)
        settingnc.tabBarItem.tag = 2
        settingnc.tabBarItem.title = "메뉴"
        settingnc.tabBarItem.image = UIImage(named: "tab_menu")
        
        viewControllers = [numnc, homenc, settingnc]
        selectedIndex = 1
    }
}

extension MainTabBarController: UINavigationControllerDelegate,
                                UITabBarControllerDelegate {
    
    override func tabBar(
        _ tabBar: UITabBar,
        didSelect item: UITabBarItem
    ) {
        print("didSelect item:", item)
    }
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        didSelect viewController: UIViewController
    ) {
        print("didSelect ViewController:", viewController.self)
    }
}

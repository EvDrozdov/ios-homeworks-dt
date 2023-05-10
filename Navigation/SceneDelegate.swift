//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Евгений Дроздов on 06.07.2022.
//

import UIKit
import FirebaseAuth


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if #available(iOS 15, *) {
            let appearence = UINavigationBarAppearance()
            appearence.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = appearence
            UINavigationBar.appearance().scrollEdgeAppearance = appearence
        }
        
        guard let windowScene  = (scene as? UIWindowScene) else { return }
        
        
        LogInViewController.loginFactoryDelegate = MyLoginFactory()
        
        self.window = UIWindow(windowScene: windowScene)
        let userFeedController = UINavigationController(rootViewController: FeedViewController())
        let loginViewController = UINavigationController(rootViewController: LogInViewController())
        let infoViewController = UINavigationController(rootViewController: InfoViewController())
        let tabBarController = UITabBarController()
        
        
        userFeedController.tabBarItem = UITabBarItem(title: NSLocalizedString("keyFeed", comment: ""),
                                                     image: UIImage(systemName: "list.bullet.rectangle.portrait"),
                                                     selectedImage: UIImage(systemName: "list.bullet.rectangle.portrait.fill"))
        
        loginViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("keyProfile", comment: ""),
                                                      image: UIImage(systemName: "brain.head.profile"),
                                                      selectedImage: UIImage(systemName: "brain.head.profile.fill"))
        
        infoViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("keyInfo", comment: ""),
                                                     image: UIImage(systemName: "info.circle"),
                                                     selectedImage: UIImage(systemName: "info.circle.fill"))
        
       
        
        
        
        tabBarController.tabBar.backgroundColor = UIColor.white
        
        tabBarController.viewControllers = [userFeedController, loginViewController, infoViewController]
        //        tabBarController.viewControllers?.enumerated().forEach {
        //            $1.tabBarItem.title = $0 == 0 ? "Feed" : "Profil"
        //            $1.tabBarItem.image = $0 == 0
        //            ? UIImage(systemName: "list.bullet.rectangle.portrait.fill")
        //            : UIImage(systemName: "brain.head.profile")
        //        }
        
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        
    }
    
    
    //            // Создаем рандомную ссылку для обращения к API
    //                    let randomValueForApi = AppConfiguration.allCases.randomElement()!
    //                    print("Ссылка, которую сформировали рандомно - ", randomValueForApi.rawValue)
    //
    //                    // Передаем ссылку в сервис для обращения к API
    //                    NetworkService.request(for: randomValueForApi)
    //        }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        try? Auth.auth().signOut()
        print("Scene disconnected")
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        if Auth.auth().currentUser == nil {
            print("User isn't login")
            
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
}



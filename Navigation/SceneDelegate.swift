//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Евгений Дроздов on 06.07.2022.
//

import UIKit

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
      
        
        userFeedController.tabBarItem = UITabBarItem(title: "Feed",
                                                 image: UIImage(systemName: "list.bullet.rectangle.portrait"),
                                                 selectedImage: UIImage(systemName: "list.bullet.rectangle.portrait.fill"))
        
        loginViewController.tabBarItem = UITabBarItem(title: "Profile",
                                                 image: UIImage(systemName: "brain.head.profile"),
                                                 selectedImage: UIImage(systemName: "brain.head.profile.fill"))
        
        infoViewController.tabBarItem = UITabBarItem(title: "Info",
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
            // Called as the scene is being released by the system.
            // This occurs shortly after the scene enters the background, or when its session is discarded.
            // Release any resources associated with this scene that can be re-created the next time the scene connects.
            // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        }
        
        func sceneDidBecomeActive(_ scene: UIScene) {
            // Called when the scene has moved from an inactive state to an active state.
            // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
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
    


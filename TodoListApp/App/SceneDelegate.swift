//
//  SceneDelegate.swift
//  TodoListApp
//
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

       func scene(_ scene: UIScene,
                  willConnectTo session: UISceneSession,
                  options connectionOptions: UIScene.ConnectionOptions) {

           guard let windowScene = (scene as? UIWindowScene) else { return }

           let window = UIWindow(windowScene: windowScene)

           let TaskListModule = TaskListRouter.createModule()
               let navController = UINavigationController(rootViewController: TaskListModule)
           
               window.rootViewController = navController
               self.window = window
               window.overrideUserInterfaceStyle = .dark 
               window.makeKeyAndVisible()
       }
}


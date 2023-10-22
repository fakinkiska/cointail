//
//  AppDelegate.swift
//  CoinTail
//
//  Created by Eugene on 16.05.23.
//

import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? // Окно приложения, координирует представление изображения
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = TabBar() // Корневой контроллер
        window?.makeKeyAndVisible() // Отображение окна
        
        RealmService.shared.readAllClasses()
        //TODO: проверить, чтобы под каждый extension был только 1 протокол во всех классах
        
        return true
    }

}

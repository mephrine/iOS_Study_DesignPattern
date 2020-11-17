//
//  AppDelegate.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/10/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  private let dependency: AppDependency
  
  // MARK: - DI
  private override init() {
    dependency = AppDependency.resolve()
    super.init()
  }
  
  init(dependency: AppDependency) {
    self.dependency = dependency
    super.init()
  }

  // MARK: - App Lifecycle
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
        
    if #available(iOS 13.0, *) {
      window?.overrideUserInterfaceStyle = .light
    }
        
    window?.backgroundColor = .white
        
        
    let navigationController = UINavigationController(rootViewController: MainViewController())
    
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
        
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
        
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
        
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
        
  }

  func applicationWillTerminate(_ application: UIApplication) {
        
  }
}


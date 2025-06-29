//
//  AppDelegate.swift
//  TransactionsTestTask
//
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    _ = CoreDataManager.shared.persistentContainer
    _ = ServicesAssembler.rateListenerLogger
    return true
  }
  
  // MARK: UISceneSession Lifecycle
  
  func application(_ application: UIApplication,
                   configurationForConnecting connectingSceneSession: UISceneSession,
                   options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
  
  func applicationWillTerminate(_ application: UIApplication) {
    CoreDataManager.shared.saveContext()
  }
}

//
//  AppDelegate.swift
//  GithubFavs
//
//  Created by Sreejith Njamelil on 13.06.21.
//

import UIKit
import RxFlow

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
  private var coordinator = FlowCoordinator()
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    guard let window = self.window else { return false }
    let appFlow = AppFlow()
    self.coordinator.coordinate(flow: appFlow, with: AppStepper())
    
    Flows.use(appFlow, when: .created) { root in
      window.rootViewController = root
      window.makeKeyAndVisible()
    }
    
    return true
  }
}


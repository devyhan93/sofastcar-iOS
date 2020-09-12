//
//  AppDelegate.swift
//  sofastcar
//
//  Created by 김광수 on 2020/08/21.
//  Copyright © 2020 김광수. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let mainVC = MainVC()
    let navigationController = UINavigationController(rootViewController: ReservationDashboardVC())
    
    let backButtonImage = UIImage(systemName: "arrow.left")
    navigationController.navigationBar.backIndicatorImage = backButtonImage
    navigationController.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
    navigationController.navigationBar.topItem?.title = ""

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = mainVC
    window?.makeKeyAndVisible()
    window?.overrideUserInterfaceStyle = .light // add woobin: dark mode off
    return true
  }

}

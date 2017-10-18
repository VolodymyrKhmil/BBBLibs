//
//  AppDelegate.swift
//  LEDESAssist
//
//  Created by admin on 9/5/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import JvSpeechRecognizer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = Rout.initial(initial: LARouter.initial)
        self.window?.makeKeyAndVisible()
        return true
    }
}


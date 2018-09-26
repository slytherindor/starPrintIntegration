//
//  AppDelegate.swift
//  starPrintIntegration
//
//  Created by Ryan on 2018-08-27.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static let settingManager = SettingManager()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let window = window {
            let mainVC = ViewController()
            let navigationController = UINavigationController(rootViewController: mainVC)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        self.loadParam()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    fileprivate func loadParam() {
        AppDelegate.settingManager.load()
    }
    
    static func getPortName() -> String {
        return settingManager.settings[0]?.portName ?? ""
    }
    
    static func setPortName(_ portName: String) {
        settingManager.settings[0]?.portName = portName
        settingManager.save()
    }
    
    static func getPortSettings() -> String {
        return settingManager.settings[0]?.portSettings ?? ""
    }
    
    static func setPortSettings(_ portSettings: String) {
        settingManager.settings[0]?.portSettings = portSettings
        settingManager.save()
    }
    
    static func getModelName() -> String {
        return settingManager.settings[0]?.modelName ?? ""
    }
    
    static func setModelName(_ modelName: String) {
        settingManager.settings[0]?.modelName = modelName
        settingManager.save()
    }
    
    static func getMacAddress() -> String {
        return settingManager.settings[0]?.macAddress ?? ""
    }
    
    static func setMacAddress(_ macAddress: String) {
        settingManager.settings[0]?.macAddress = macAddress
        settingManager.save()
    }
    
    static func getEmulation() -> StarIoExtEmulation {
        return settingManager.settings[0]?.emulation ?? .starPRNT
    }
    
    static func setEmulation(_ emulation: StarIoExtEmulation) {
        settingManager.settings[0]?.emulation = emulation
        settingManager.save()
    }
    
    static func getCashDrawerOpenActiveHigh() -> Bool {
        return settingManager.settings[0]?.cashDrawerOpenActiveHigh ?? true
    }
    
    static func setCashDrawerOpenActiveHigh(_ activeHigh: Bool) {
        settingManager.settings[0]?.cashDrawerOpenActiveHigh = activeHigh
        settingManager.save()
    }
    
    static func getSelectedPaperSize() -> PaperSizeIndex {
        return AppDelegate.settingManager.settings[0]?.selectedPaperSize ?? .threeInch
    }
    
    static func setSelectedPaperSize(_ index: PaperSizeIndex) {
        AppDelegate.settingManager.settings[0]?.selectedPaperSize = index
        settingManager.save()
    }

}


//
//  SettingsManager.swift
//  starPrintIntegration
//
//  Created by Ryan on 2018-08-29.
//  Copyright © 2018 Ryan. All rights reserved.
//

import Foundation

class SettingManager: NSObject {
    var settings: [PrinterSetting?]
    
    override init() {
        self.settings = [nil, nil]
        
        super.init()
    }
    
    func save() {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: settings)
        UserDefaults.standard.set(encodedData, forKey: "setting")
        UserDefaults.standard.synchronize()
    }
    
    func load() {
        let optEncodedData = UserDefaults.standard.data(forKey: "setting")
        if let encodedData = optEncodedData {
            self.settings = NSKeyedUnarchiver.unarchiveObject(with: encodedData) as? [PrinterSetting?] ?? [nil, nil]
        }
    }
}

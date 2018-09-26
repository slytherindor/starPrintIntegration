//
//  PrinterSetting.swift
//  starPrintIntegration
//
//  Created by Ryan on 2018-08-29.
//  Copyright © 2018 Ryan. All rights reserved.
//

import Foundation

enum PaperSizeIndex: Int {
    case twoInch = 384
    case threeInch = 576
    case fourInch = 832
    case escPosThreeInch = 512
    case dotImpactThreeInch = 210
}

class PrinterSetting: NSObject, NSCoding {
    var portName: String
    
    var portSettings: String
    
    var modelName: String
    
    var macAddress: String
    
    var emulation: StarIoExtEmulation
    
    var cashDrawerOpenActiveHigh: Bool
    
    
    var selectedPaperSize: PaperSizeIndex
    
    
    init(portName: String, portSettings: String, macAddress: String, modelName: String,
         emulation: StarIoExtEmulation, cashDrawerOpenActiveHigh: Bool,
         selectedPaperSize: PaperSizeIndex) {
        self.portName = portName
        self.portSettings = portSettings
        self.macAddress = macAddress
        self.modelName = modelName
        self.emulation = emulation
        self.cashDrawerOpenActiveHigh = cashDrawerOpenActiveHigh
        self.selectedPaperSize = selectedPaperSize
        super.init()
        print(self)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.portName = aDecoder.decodeObject(forKey: "portName") as? String ?? ""
        self.portSettings = aDecoder.decodeObject(forKey: "portSettings") as? String ?? ""
        self.macAddress = aDecoder.decodeObject(forKey: "macAddress") as? String ?? ""
        self.modelName = aDecoder.decodeObject(forKey: "modelName") as? String ?? ""
        self.emulation = StarIoExtEmulation(rawValue: aDecoder.decodeInteger(forKey: "emulation"))!
        self.cashDrawerOpenActiveHigh = aDecoder.decodeBool(forKey: "cashDrawerOpenActiveHigh")
        self.selectedPaperSize = PaperSizeIndex(rawValue: aDecoder.decodeInteger(forKey: "selectedPaperSize")) ?? PaperSizeIndex.twoInch
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(portName, forKey: "portName")
        aCoder.encode(portSettings, forKey: "portSettings")
        aCoder.encode(macAddress, forKey: "macAddress")
        aCoder.encode(modelName, forKey: "modelName")
        aCoder.encode(emulation.rawValue, forKey: "emulation")
        aCoder.encode(cashDrawerOpenActiveHigh, forKey: "cashDrawerOpenActiveHigh")
        aCoder.encode(selectedPaperSize.rawValue, forKey: "selectedPaperSize")
    }
    
    override var description: String {
        return """
        PrinterSetting
        {
        portName: \(self.portName)
        portSettings: \(self.portSettings)
        macAddress: \(self.macAddress)
        modelName: \(self.modelName)
        emulation: \(self.emulation.rawValue)
        cashDrawerOpenActiveHigh: \(self.cashDrawerOpenActiveHigh)
        selectedPaperSize: \(self.selectedPaperSize)
        }
        """
    }
    
}


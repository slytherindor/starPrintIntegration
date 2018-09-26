//
//  PrinterCapability.swift
//  starPrintIntegration
//
//  Created by Ryan on 2018-08-30.
//  Copyright © 2018 Ryan. All rights reserved.
//

import Foundation

class PrinterInfo {
    let title: String
    
    let emulation: StarIoExtEmulation
    
    let supportedExternalCashDrawer: Bool
    
    let portSettings: String
    
    let modelNameArray: [String]
    
    let textReceiptIsEnabled: Bool
    
    let UTF8IsEnabled: Bool
    
    let rasterReceiptIsEnabled: Bool
    
    let CJKIsEnabled: Bool
    
    let blackMarkIsEnabled: Bool
    
    let blackMarkDetectionIsEnabled: Bool
    
    let pageModeIsEnabled: Bool
    
    let cashDrawerIsEnabled: Bool
    
    let barcodeReaderIsEnabled: Bool
    
    let customerDisplayIsEnabled: Bool
    
    let AllReceiptsIsEnabled: Bool
    
    let productSerialNumberIsEnabled: Bool
    
    let supportBluetoothDisconnection: Bool
    
    init(_ title: String,
         _ emulation: StarIoExtEmulation,
         _ supportedExternalCashDrawer: Bool,
         _ portSettings: String,
         _ modelNameArray: [String],
         _ textReceiptIsEnabled: Bool,
         _ UTF8IsEnabled: Bool,
         _ rasterReceiptIsEnabled: Bool,
         _ CJKIsEnabled: Bool,
         _ blackMarkIsEnabled: Bool,
         _ blackMarkDetectionIsEnabled: Bool,
         _ pageModeIsEnabled: Bool,
         _ cashDrawerIsEnabled: Bool,
         _ barcodeReaderIsEnabled: Bool,
         _ customerDisplayIsEnabled: Bool,
         _ AllReceiptsIsEnabled: Bool,
         _ productSerialNumberIsEnabled: Bool,
         _ supportBluetoothDisconnection: Bool
        ) {
        self.title = title
        self.emulation = emulation
        self.supportedExternalCashDrawer = supportedExternalCashDrawer
        self.portSettings = portSettings
        self.modelNameArray = modelNameArray
        
        self.textReceiptIsEnabled = textReceiptIsEnabled
        self.UTF8IsEnabled = UTF8IsEnabled
        self.rasterReceiptIsEnabled = rasterReceiptIsEnabled
        self.CJKIsEnabled = CJKIsEnabled
        self.blackMarkIsEnabled = blackMarkIsEnabled
        self.blackMarkDetectionIsEnabled = blackMarkDetectionIsEnabled
        self.pageModeIsEnabled = pageModeIsEnabled
        self.cashDrawerIsEnabled = cashDrawerIsEnabled
        self.barcodeReaderIsEnabled = barcodeReaderIsEnabled
        self.customerDisplayIsEnabled = customerDisplayIsEnabled
        self.AllReceiptsIsEnabled = AllReceiptsIsEnabled
        self.productSerialNumberIsEnabled = productSerialNumberIsEnabled
        self.supportBluetoothDisconnection = supportBluetoothDisconnection
    }
    
    static var tsp650ii = PrinterInfo("TSP650II", .starLine, true, "", ["TSP654II (STR_T-001)", "TSP654 (STR_T-001)", "TSP651(STR_T-001)"],true, true, true, true, false, false, true, true, false, false, true, false, true);
}

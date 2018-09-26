//
//  PrinterService.swift
//  starPrintIntegration
//
//  Created by Ryan on 2018-08-28.
//  Copyright © 2018 Ryan. All rights reserved.
//

import Foundation

typealias SendCompletionHandler = (_ result: Bool, _ title: String, _ message: String) -> Void

enum PrinterResponse: String {
    case PortNotAvailable = "Failed to open port."
    case PrinterOffline = "Printer is offline."
    case PrintSuceeded = "Print Succeeded."
    case PrintTimeout = "Timeout!"
    case UnknownError = "Something went wrong."
}

class PrinterService {
    
    let sm_true:  UInt32 = 1     // SM_TRUE
    let sm_false: UInt32 = 0
    var portName: String;
    var dataToPrint: Data;
    var portSettings: String;
    init(portName: String, portSettings: String, dataToPrint: Data) {
        self.portName = portName;
        self.portSettings = portSettings;
        self.dataToPrint = dataToPrint;
        
    }
    
    func printData(completionHandler: SendCompletionHandler?) -> Bool {
        let dataToSend = [UInt8](self.dataToPrint)
        var bytesWritten: UInt32 = 0;
        var starPrinterStatus:StarPrinterStatus_2 = StarPrinterStatus_2.init();
        var error: NSError?;
        
        var result: Bool = false
        var title:   String = ""
        var message: String = ""
        
        while true {
            guard let port = SMPort.getPort(self.portName, self.portSettings, 10000) else{
                title = PrinterResponse.PortNotAvailable.rawValue
                break
            }
            
            defer {
                SMPort.release(port)
            }
            port.beginCheckedBlock(&starPrinterStatus, 2, &error);
            
            if(starPrinterStatus.offline == sm_true){
                title = PrinterResponse.PrinterOffline.rawValue
                break
            }
            
            let startDate: Date = Date()
            while bytesWritten < UInt32(dataToSend.count) {
                bytesWritten += (port.write(dataToSend, bytesWritten, UInt32(dataToSend.count) - bytesWritten, &error));
                if error != nil {
                    break
                }
                
                if Date().timeIntervalSince(startDate) >= 30.0 {     // 30000mS!!!
                    title   = "Printer Error"
                    message = "Write port timed out"
                    break
                }
            }
            port.endCheckedBlock(&starPrinterStatus, 2, &error);
            
            if(starPrinterStatus.offline == sm_true){
                title = PrinterResponse.PrinterOffline.rawValue
                break
                
            }
            
            title = PrinterResponse.PrintSuceeded.rawValue
            result = true
            break
        }
        
        if error != nil {
            title = PrinterResponse.UnknownError.rawValue
            message = "Please try again."
        }
        
        if completionHandler != nil {
            completionHandler!(result, title, message)
        }
        return result
    }        
        
}

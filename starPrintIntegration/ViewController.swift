//
//  ViewController.swift
//  starPrintIntegration
//
//  Created by Ryan on 2018-08-27.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum SectionIndex: Int {
        case device = 0
        case printer
        case deviceStatus
        case interface
        case firmware
    }
    
    private var printerInformation: UITableView!
    var selectedIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        printerInformation = UITableView.init(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight));
        printerInformation.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        printerInformation.dataSource = self;
        printerInformation.delegate = self;
        self.view.addSubview(printerInformation)
        self.selectedIndexPath = nil
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.printerInformation.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionIndex.firmware.rawValue + 1;
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title: String!
        
        switch SectionIndex(rawValue: section)! {
        case SectionIndex.device:
            title = "Destination Printer"
        case SectionIndex.printer:
            title = "Printer"
        case SectionIndex.deviceStatus:
            title = "Printer Status"
        case SectionIndex.interface:
            title = "Interface"
        case SectionIndex.firmware:
            title = "Firmware Information"
        }
        
        return title
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionIndex.device.rawValue {
            return 1
        }
        
        if section == SectionIndex.printer.rawValue {
            return 2
        }
        
        if section == SectionIndex.deviceStatus.rawValue {
            return 1
        }
        
        if section == SectionIndex.interface.rawValue {
            return 3
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if SectionIndex(rawValue: indexPath.section) == SectionIndex.device {
            
            
            if AppDelegate.settingManager.settings[0] == nil {
                let cellIdentifier = "DestinationCellEmpty"
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
                cell.textLabel?.text = "Unspecified"
                cell.detailTextLabel?.text = ""
                cell.backgroundColor = UIColor.red
            }else{
                
                let currentSetting = AppDelegate.settingManager.settings[indexPath.row]!
                let cellIdentifier: String = "DestinationCellEmpty"
                cell = self.printerInformation.dequeueReusableCell(withIdentifier: cellIdentifier)
                if cell == nil {
                    cell = UITableViewCell(style: UITableViewCellStyle.subtitle,
                                           reuseIdentifier: cellIdentifier)
                }
                
                cell.textLabel!.text = currentSetting.modelName
                cell.backgroundColor = UIColor.white
                if currentSetting.macAddress == "" {
                    cell.detailTextLabel!.text = currentSetting.portName
                } else {
                    cell.detailTextLabel!.text = "\(currentSetting.portName) (\(currentSetting.macAddress))"
                }
            }
            
        }else{
            let cellIdentifier = "NormalCell"
            cell = self.printerInformation.dequeueReusableCell(withIdentifier: cellIdentifier)
            
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            }
            if cell != nil {
                switch SectionIndex(rawValue: indexPath.section)! {
                case SectionIndex.printer:
                    cell.backgroundColor = UIColor.white
                    
                    switch indexPath.row {
                    case 0:
                        cell.textLabel!.text = "Receipt Sample"
                    default:
                        cell.textLabel!.text = "QR Code"
                    }
                case SectionIndex.deviceStatus:
                    cell.backgroundColor = UIColor.white
                    
                    switch indexPath.row {
                    default:
                        cell.textLabel!.text = "Status Information"
                    }
                case SectionIndex.interface:
                    switch indexPath.row {
                    case 0 :
                        cell.textLabel!.text = "Pairing and Connect Bluetooth"
                        
                    case 1 :
                        cell .textLabel!.text = "Disconnect Bluetooth"
                        
                    //                  case 2  :
                    default :
                        cell.textLabel!.text = "Bluetooth Settings"
                        
                    }
                default:
                    cell.textLabel?.text = "Firmware Version"
                    
                }
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.printerInformation.deselectRow(at: indexPath, animated: true)
        
        self.selectedIndexPath = indexPath
        
        switch SectionIndex(rawValue: self.selectedIndexPath.section)! {
        case SectionIndex.device :
            let searchBT = SearchBTPortVC()
            self.navigationController?.pushViewController(searchBT, animated: true)
        case SectionIndex.printer:
            let currentSetting = AppDelegate.settingManager.settings[0]!
            if self.selectedIndexPath.row == 0 {
                let printData = CommandBuilder.create2InchReceiptData(currentSetting.emulation, utf8: true)
                let printerService = PrinterService.init(portName: currentSetting.portName, portSettings: currentSetting.portSettings, dataToPrint: printData)
                DispatchQueue.main.async {
                    _ = printerService.printData(completionHandler: {
                        (result: Bool, title: String, message: String) in
                        DispatchQueue.main.async {
                            self.showPrinterResponse(title: title, message: message)
                        }
                    })
                }
                
            } else if self.selectedIndexPath.row == 1 {
                let printData = CommandBuilder.creatreQRCodeData(currentSetting.emulation, utf8: true)
                let printerService = PrinterService.init(portName: currentSetting.portName, portSettings: currentSetting.portSettings, dataToPrint: printData)
                DispatchQueue.main.async {
                    _ = printerService.printData(completionHandler: {
                        (result: Bool, title: String, message: String) in
                        DispatchQueue.main.async {
                            self.showPrinterResponse(title: title, message: message)
                        }
                    })
                }
                
            }
        case SectionIndex.deviceStatus :
            if self.selectedIndexPath.row == 0 {
            }
            else {
                
            }
        case SectionIndex.interface :
            if self.selectedIndexPath.row == 0 {
                
            }
            else if self.selectedIndexPath.row == 1 {
        
            }
            else {
            }
        //case SectionIndex.appendix:
        default:
            self.showFirmwareVersion ()
        }

    }

    func showFirmwareVersion () {
        let message = """
        StarIO version \(SMPort.starIOVersion() ?? "")
        \(StarIoExt.description() ?? "")
        """
        let alertController = UIAlertController(title: "Firmware Version",
                                                message: message,
                                                preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showPrinterResponse(title: String, message: String){
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

//
//  SearchBTPortVC.swift
//  starPrintIntegration
//
//  Created by Ryan on 2018-08-29.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit

class SearchBTPortVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    enum CellParamIndex: Int {
        case portName = 0
        case modelName
        case macAddress
    }
    
    
    var tableView: UITableView!
    var cellArray: Array<Any> = [];
    var selectedIndexPath: IndexPath!
    var portName:     String!
    var portSettings: String!
    var modelName:    String!
    var macAddress:   String!
    var paperSizeIndex: PaperSizeIndex? = nil
    var emulation: StarIoExtEmulation!
    var isCashDrawerOpenActiveHigh: Bool = true
    var selectedPrinterIndex: Int = 0
    var currentSetting: PrinterSetting? = nil
    var didAppear: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .done, target: self, action: #selector(performRefreshDeviceList))
        self.currentSetting = AppDelegate.settingManager.settings[selectedPrinterIndex]
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        tableView = UITableView.init(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight));
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.dataSource = self;
        tableView.delegate = self;
        self.view.addSubview(tableView)
        self.didAppear = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.didAppear == false {
            self.performRefreshDeviceList()
            
            
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Printers Discovered"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "BTPrintersCellStyle"
        
        var cell: UITableViewCell! = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        if cell != nil {
            let cellParam: [String] = self.cellArray[indexPath.row] as! [String]
            
            cell.textLabel!.text = cellParam[CellParamIndex.modelName.rawValue]
            
            if cellParam[CellParamIndex.macAddress.rawValue] == "" {
                cell.detailTextLabel!.text = cellParam[CellParamIndex.portName.rawValue]
            }
            else {
                cell.detailTextLabel!.text = "\(cellParam[CellParamIndex.portName.rawValue]) (\(cellParam[CellParamIndex.macAddress.rawValue]))"
            }
            
            cell.accessoryType = UITableViewCellAccessoryType.none
            
            if cellParam[CellParamIndex.portName.rawValue] == AppDelegate.settingManager.settings[self.selectedPrinterIndex]?.portName {
                cell.accessoryType = .checkmark
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cell: UITableViewCell!
        
        if self.selectedIndexPath != nil {
            cell = tableView.cellForRow(at: self.selectedIndexPath)
            
            if cell != nil {
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
        }
        
        cell = tableView.cellForRow(at: indexPath)!
        
        _ = tableView.visibleCells.map{ $0.accessoryType = .none }
        cell.accessoryType = UITableViewCellAccessoryType.checkmark
        
        self.selectedIndexPath = indexPath
        
        let cellParam: [String] = self.cellArray[self.selectedIndexPath.row] as! [String]
        let modelName:  String = cellParam[CellParamIndex.modelName.rawValue]
        
        if modelName == "Star Micronics" {
            let confirmTsp = UIAlertController.init(title: "Is your printer TSP650II",
                                                    message: "",
                                                    preferredStyle: .alert)
            
            confirmTsp.addAction(UIAlertAction(title: "Yes",
                                               style: .default,
                                               handler:{_ in
                                                self.didSelectCorrectPrinterType(cellParams: cellParam)
                                                
            }))
            confirmTsp.addAction(UIAlertAction(title: "No",
                                               style: .destructive,
                                               handler:{_ in
                                                self.promptAnotherSelection()
                                                cell.setSelected(false, animated: true)
                                                cell.accessoryType = UITableViewCellAccessoryType.none
                                                
            }))
            
            self.present(confirmTsp, animated: true, completion: nil)
        }

        
        
    }
    
    
    func didSelectCorrectPrinterType(cellParams: [String]){
        self.portName = cellParams[CellParamIndex.portName.rawValue]
        self.modelName = cellParams[CellParamIndex.modelName.rawValue]
        self.macAddress = cellParams[CellParamIndex.macAddress.rawValue]

        self.portSettings = PrinterInfo.tsp650ii.portSettings
        self.emulation = PrinterInfo.tsp650ii.emulation
        self.paperSizeIndex = nil
//        self.paperSizeIndex = AppDelegate.settingManager.settings[0]?.selectedPaperSize
        
        let supportedExternalCashDrawer = PrinterInfo.tsp650ii.supportedExternalCashDrawer
        if self.paperSizeIndex == nil {
            self.selectPaperSize()
        } else {
            if supportedExternalCashDrawer == true {
                self.selectCashDrawerStatus()
                
            } else {
//                self.saveParams(portName: self.portName,
//                                portSettings: self.portSettings,
//                                modelName: self.modelName,
//                                macAddress: self.macAddress,
//                                emulation: self.emulation,
//                                isCashDrawerOpenActiveHigh: true,
//                                modelIndex: self.selectedModelIndex,
//                                paperSizeIndex: self.paperSizeIndex)

            }
        }
    }
    
    @objc func performRefreshDeviceList(){
        let alert = self.createSearchActivityIndicator()
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.async {
            self.refreshPortInfo()
            self.dismiss(animated: true, completion: nil)
            self.didAppear = true
        }
    }
    
    func refreshPortInfo() {
        let alert = self.createSearchActivityIndicator()
        present(alert, animated: true, completion: nil)
        self.cellArray = []
        let searchPrinterResult: [PortInfo]?
        searchPrinterResult = SMPort.searchPrinter("BT:")  as? [PortInfo]
        
        guard let portInfoArray: [PortInfo] = searchPrinterResult else {
            self.tableView.reloadData()
            return
        }
        
        let portName:   String = currentSetting?.portName ?? ""
        let modelName:  String = currentSetting?.portSettings ?? ""
        let macAddress: String = currentSetting?.macAddress ?? ""
        
        var row: Int = 0
        
        for portInfo: PortInfo in portInfoArray {
            self.cellArray.append([portInfo.portName, portInfo.modelName, portInfo.macAddress])
            
            if portInfo.portName   == portName  &&
                portInfo.modelName  == modelName &&
                portInfo.macAddress == macAddress {
                self.selectedIndexPath = IndexPath(row: row, section: 0)
            }
            
            row += 1
        }
        
        self.tableView.reloadData()
        
    }
    
    func promptAnotherSelection(){
        let message = "This application only supports TSP650II.\nPlease connect it if available"
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .cancel,
                                                handler:nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func selectPaperSize(){
        let title = "Select Paper Size"
        let paperSizes: [String] = ["2\" - 384dots", "3\" - 576dots", "4\" - 832dots"]
        let alertController = UIAlertController(title: title,
                                                message: "",
                                                preferredStyle: .alert)
        
        for (index,paper) in paperSizes.enumerated(){
            alertController.addAction(UIAlertAction(title: paper,
                                                    style: .default,
                                                    handler:{ action in
                                                        self.didSelectPaperSize(buttonIndex: index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func didSelectPaperSize(buttonIndex: Int){
        switch buttonIndex {
        case 0:
            self.paperSizeIndex = .twoInch
        case 1:
            self.paperSizeIndex = .threeInch
        case 2:
            self.paperSizeIndex = .fourInch
        default:
            fatalError()
        }
        selectCashDrawerStatus()
    }
    
    func selectCashDrawerStatus(){
        let title = "Select Cash Drawer Status"
        let statuses: [String] = ["High when Open", "Low when Open"]
        let alertController = UIAlertController(title: title,
                                                message: "",
                                                preferredStyle: .alert)
        
        for (index,status) in statuses.enumerated(){
            alertController.addAction(UIAlertAction(title: status,
                                                    style: .default,
                                                    handler:{ action in
                                                        self.didSelectCashDrawerOpenActiveHigh(buttonIndex: index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func didSelectCashDrawerOpenActiveHigh(buttonIndex: Int) {
        if buttonIndex == 0 {     // High when Open
            self.isCashDrawerOpenActiveHigh = true
        }
        else if buttonIndex == 1 {     // Low when Open
            self.isCashDrawerOpenActiveHigh = false
        } else {
            fatalError()
        }
        
        self.askToSave();
        
    }
    
    func askToSave(){
        let title = "Confirm Selection"
        let message = "\(String(describing: self.portName))\n\(String(describing: self.paperSizeIndex?.rawValue)) Dots\n Cash Drawer open when High: \(self.isCashDrawerOpenActiveHigh)"
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Save",
                                                style: .default,
                                                handler:{_ in
                                                    self.saveParams(portName: self.portName, portSettings: self.portSettings, modelName: self.modelName, macAddress: self.macAddress, emulation: self.emulation, isCashDrawerOpenActiveHigh: self.isCashDrawerOpenActiveHigh, paperSizeIndex: self.paperSizeIndex)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel",
                                                style: .destructive,
                                                handler:{_ in
                                                var cell: UITableViewCell!
                                                cell = self.tableView.cellForRow(at: self.selectedIndexPath)!
                                                cell.setSelected(false, animated: true)
                                                cell.accessoryType = UITableViewCellAccessoryType.none
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func saveParams(portName: String,
                    portSettings: String,
                    modelName: String,
                    macAddress: String,
                    emulation: StarIoExtEmulation,
                    isCashDrawerOpenActiveHigh: Bool,
                    paperSizeIndex: PaperSizeIndex?) {
            if let paperSizeIndex = paperSizeIndex {
            AppDelegate.settingManager.settings[selectedPrinterIndex] = PrinterSetting(portName: portName,
                                                                                       portSettings: portSettings,
                                                                                       macAddress: macAddress,
                                                                                       modelName: modelName,
                                                                                       emulation: emulation,
                                                                                       cashDrawerOpenActiveHigh: isCashDrawerOpenActiveHigh,
                                                                                       selectedPaperSize: paperSizeIndex
                                                                                       )
            
            AppDelegate.settingManager.save()
        } else {
            fatalError()
        }
    }
    
    func createSearchActivityIndicator() -> UIAlertController {
        let alert = UIAlertController(title: "Search in progress", message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        
        return alert
        
    }
    
    
}

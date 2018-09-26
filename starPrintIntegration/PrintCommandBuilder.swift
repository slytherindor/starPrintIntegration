//
//  PrintCommandBuilder.swift
//  starPrintIntegration
//
//  Created by Ryan on 2018-08-30.
//  Copyright © 2018 Ryan. All rights reserved.
//

import Foundation

class CommandBuilder {
    static func create2InchReceiptData(_ emulation: StarIoExtEmulation, utf8: Bool) -> Data{
        let builder: ISCBBuilder = StarIoExt.createCommandBuilder(emulation)
        let maxChars = 32;
        let encoding: String.Encoding
        
        builder.beginDocument()
        
        if utf8 == true {
            encoding = String.Encoding.utf8
            
            builder.append(SCBCodePageType.UTF8)
        }
        else {
            encoding = String.Encoding.ascii
            
            builder.append(SCBCodePageType.CP998)
        }
        
        builder.append(SCBInternationalType.USA)
        builder.appendCharacterSpace(0)
        builder.appendAlignment(SCBAlignmentPosition.left)
        builder.appendData(withEmphasis: "SALE\n".data(using: encoding))
        
        var headerArray = ["SKU", "Description", "Total"]
        let itemArray = ["300678566", "PLAIN T-SHIRT", "10.99"]
        let itemArray1 = ["300692003","BLACK DENIM","29.99"]
        let itemArray2 = ["300651148","BLUE DENIM","29.99"]
        let itemArray3 = ["300642980","STRIPED DRESS","49.99"]
        let itemArray4 = ["300638471","BLACK BOOTS","35.99"]
        
        
        let header = centerAlign2Inch3ColHeader(strings: headerArray)
        let fir = NSString.init(string: header).range(of: headerArray[1]).location
        let item1 = centerAlign2InchItems(strings: itemArray, secondColumnCharIndex: fir)
        let item2 = centerAlign2InchItems(strings: itemArray1, secondColumnCharIndex: fir)
        let item3 = centerAlign2InchItems(strings: itemArray2, secondColumnCharIndex: fir)
        let item4 = centerAlign2InchItems(strings: itemArray3, secondColumnCharIndex: fir)
        let item5 = centerAlign2InchItems(strings: itemArray4, secondColumnCharIndex: fir)
        let arrayLines = [header, item1, item2, item3, item4, item5]
        builder.append(arrayLines.joined(separator: "\n").data(using: encoding))
        builder.appendCutPaper(SCBCutPaperAction.partialCutWithFeed)
        
        builder.endDocument()
        
        return builder.commands.copy() as! Data
    }
    
    static func creatreQRCodeData(_ emulation: StarIoExtEmulation, utf8: Bool) -> Data{
        let builder: ISCBBuilder = StarIoExt.createCommandBuilder(emulation)
        let maxChars = 32;
        let encoding: String.Encoding
        
        builder.beginDocument()
        
        if utf8 == true {
            encoding = String.Encoding.utf8
            
            builder.append(SCBCodePageType.UTF8)
        }
        else {
            encoding = String.Encoding.ascii
            
            builder.append(SCBCodePageType.CP998)
        }
        
        builder.append(SCBInternationalType.USA)
        builder.appendCharacterSpace(0)
        builder.appendQrCodeData("Hello World".data(using: .utf8), model: .no2, level: .H, cell: 1)
        builder.appendCutPaper(SCBCutPaperAction.partialCutWithFeed)
        
        builder.endDocument()
        
        return builder.commands.copy() as! Data
        
    }
    
    static func centerAlign2Inch2ColHeader(strings: [String]) -> String {
        let numberOfSpaces = 32 - strings.joined(separator: "").count
        return strings.joined(separator: String(repeating: " ", count: numberOfSpaces))
    }
    
    static func centerAlign2Inch3ColHeader(strings: [String]) -> String {
        var leftSpaces = 32
        for string in strings{
            leftSpaces -= string.count
        }
        let joinedString = strings.joined(separator: "")
        var firstSpaces = 16 - joinedString.count/2
        leftSpaces -= firstSpaces
        firstSpaces += leftSpaces + 1
        let secondSpaces = leftSpaces - 1
        let stringSpaced: String = strings[0] + String(repeating: " ", count: firstSpaces) + strings[1] + String(repeating: " ", count: secondSpaces) + strings[2]
        return stringSpaced
    }
    
    static func centerAlign2InchItems(strings: [String], secondColumnCharIndex: Int) -> String {
        var leftSpaces = 32
        for string in strings{
            leftSpaces -= string.count
        }
        let firstSpaces = secondColumnCharIndex - strings[0].count
        let secondSpaces = leftSpaces - 1
        let stringSpaced: String = strings[0] + String(repeating: " ", count: firstSpaces) + strings[1] + String(repeating: " ", count: secondSpaces) + strings[2]
        return stringSpaced
    }
    
    
        
        
    
}

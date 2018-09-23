//
//  Resolver.swift
//  BarcodeTypeResolver
//
//  Created by Stuart Williams on 17/09/2018.
//  Copyright © 2018 Stuart Williams. All rights reserved.
//

import Foundation
import AVFoundation

public class Resolver {
    
    public init() {}
    
    public func isISBN(barcode: String) -> Bool {
  
        return ISBNValidator.verifyISBN13(barcode) || ISBNValidator.verifyISBN10(barcode)
    }
    
    public func checkType(type: String, val: String) -> BarcodeType {
        
        switch(type) {
            
        case "org.gs1.EAN-13":
            if isISBN(barcode: val) {
                return BarcodeType.isbn
            }
            return BarcodeType.ean13
            
        case "org.gs1.EAN-8":
            return BarcodeType.ean8
            
        case "org.gs1.UPC-E":
            return BarcodeType.upce
            
        default:
            return BarcodeType.unknown
        }
    }
}

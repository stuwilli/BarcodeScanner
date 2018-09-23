//
//  BarcodeType.swift
//  BarcodeTypeResolver
//
//  Created by Stuart Williams on 17/09/2018.
//  Copyright © 2018 Stuart Williams. All rights reserved.
//

import Foundation

public enum BarcodeType:String {
    case ean13 = "EAN13"
    case ean8 = "EAN8"
    case upce = "UPCE"
    case isbn = "ISBN"
    case unknown = "UNKNOWN"
}

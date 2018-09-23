//
//  BarcodeTypeResolverTests.swift
//  BarcodeTypeResolverTests
//
//  Created by Stuart Williams on 17/09/2018.
//  Copyright © 2018 Stuart Williams. All rights reserved.
//

import XCTest
import AVFoundation
@testable import BarcodeTypeResolver
//import BarcodeTypeResolver

class BarcodeTypeResolverTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsISBN() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let r = Resolver()
        XCTAssertTrue(r.isISBN(barcode: "9783161484100")) //ISBN 13
        XCTAssertTrue(!r.isISBN(barcode: "9783161484101")) //Invalid ISBN
        XCTAssertTrue(!r.isISBN(barcode: "5901234123457")) //Standard EAN Code
        XCTAssertTrue(r.isISBN(barcode: "0140266909")) //ISBN 10
        
    }
    
    func testCheckType() {
        
        let r = Resolver()
        
        XCTAssertEqual(r.checkType(type: "org.gs1.EAN-13", val: "9783161484100"), BarcodeType.isbn)
        XCTAssertEqual(r.checkType(type: "org.gs1.EAN-13", val: "9783161484101"), BarcodeType.ean13)
        XCTAssertEqual(r.checkType(type: "org.gs1.EAN-13", val: "0140266909"), BarcodeType.isbn)
        XCTAssertEqual(r.checkType(type: "org.gs1.EAN-13", val: "5901234123457"), BarcodeType.ean13)
    }
    
}

//
//  ISBN.swift
//  BarcodeTypeResolver
//
//  Created by Stuart Williams on 22/09/2018.
//  Copyright © 2018 Stuart Williams. All rights reserved.
//

import Foundation

class ISBNValidator {
    
    public static func verifyISBN13(_ input: String) -> Bool {
        
        let factor = [1, 3]
        var checksum = 0
        let regEx =  "^(?:[0-9]{13})$"
        
        if input.range(of: regEx, options: [.regularExpression, .anchored]) == nil {
            return false
        }
        
        if input.prefix(3) != "978" {
            return false
        }
        
        for i in 0..<12 {
            if let intCharacter = Int(String(input[input.index(input.startIndex, offsetBy: i)])) {
                print("\(factor[i%2]) * \(intCharacter)")
                checksum += factor[i % 2] * intCharacter
            }
        }
        
        if let lastInt = Int(String(input[input.index(input.startIndex, offsetBy: 12)])) {
            return (lastInt - ((10 - (checksum % 10)) % 10) == 0)
        }
        
        return false
    }
    
    public static func verifyISBN10(_ input: String) -> Bool {
        
        var checksum = 0
        let regEx = "^(?:[0-9]{9}X|[0-9]{10})$"
        
        if input.range(of: regEx, options: [.regularExpression, .anchored]) == nil {
            print("FAILED REGEX")
            return false
        }
        
        for i in 0..<9 {
            if let intCharacter = Int(String(input[input.index(input.startIndex, offsetBy: i)])) {
                checksum += (i + 1) * intCharacter
            }
        }
        
        if (input[input.index(input.startIndex, offsetBy: 9)] == "X") {
            checksum += 10 * 10
        } else {
            if let intCharacter = Int(String(input[input.index(input.startIndex, offsetBy: 9)])) {
                checksum += 10 * intCharacter
            }
        }
        
        return ((checksum % 11) == 0)
    }
    
    
}

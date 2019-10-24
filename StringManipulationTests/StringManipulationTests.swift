//
//  StringManipulationTests.swift
//  StringManipulationTests
//
//  Created by Jehad Sarkar on 2019-10-23.
//  Copyright © 2019 itsjehad. All rights reserved.
//



import XCTest


@testable import StringManipulation

extension String {
  subscript(_ i: Int) -> String {
    let idx1 = index(startIndex, offsetBy: i)
    let idx2 = index(idx1, offsetBy: 1)
    return String(self[idx1..<idx2])
  }

  subscript (r: Range<Int>) -> String {
    let start = index(startIndex, offsetBy: r.lowerBound)
    let end = index(startIndex, offsetBy: r.upperBound)
    return String(self[start ..< end])
  }

  subscript (r: CountableClosedRange<Int>) -> String {
    let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
    let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
    return String(self[startIndex...endIndex])
  }
}



class StringManipulationTests: XCTestCase {
    let numCharacters = ["", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"]
    func phoneDigitToStringCombination(_ phoneNumber: String, _ parent: String){
        if phoneNumber.count > 0 {
            let char = phoneNumber[0]
            if let intChar = Int(char){
                
                for i in 0 ..< numCharacters[intChar].count{
                    let newParent = parent + numCharacters[intChar][i]
                    phoneDigitToStringCombination(phoneNumber[1 ..< phoneNumber.count], newParent)
                    
                }
            }
        }
        else{
            print(parent)
        }
    }

    func testPhoneDigitToStringCobmination(){
        phoneDigitToStringCombination("234", "")
    }

}

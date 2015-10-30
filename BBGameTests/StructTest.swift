//
//  StructTest.swift
//  BBGame
//
//  Created by Steven Journeay on 10/30/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//
import XCTest
@testable import BBGame

class StructTest: XCTestCase {
    
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
    
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testUInt8() {
    let testValue:UInt = 1
    // pack a byte
    let nsdata:NSData = Struct.pack("B", values:[testValue])
    XCTAssert(nsdata.length == 1)
        
    // unpack a byte
    let udata:[AnyObject] = Struct.unpack("B", data:nsdata)
    XCTAssert(udata.count == 1)
    if udata.count > 0 {
      if let value = udata[0] as? UInt {
        XCTAssert(value == testValue)
      } else {
        XCTAssert(false, "value is not a Uint")
      }
    }
  }
  
/*
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measureBlock {
      // Put the code you want to measure the time of here.
    }
  }
*/
}

//
//  SelectionsTest.swift
//  BBGame
//
//  Created by Steven Journeay on 10/30/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import XCTest
@testable import BBGame

class SelectionsTest: XCTestCase {
    
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
    
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
    
  func testCreate() {
    let lst:[BB] = [BB.OUT, BB.SINGLE, BB.DOUBLE, BB.TRIPLE, BB.HOMERUN, BB.ERROR_1B, BB.ERROR_2B]
    for (i,value) in lst.enumerate() {
      let se = Selection(sel:value, index:i)
      XCTAssert(se.sel == value)
      XCTAssert(se.used == false)
      XCTAssert(se.index == i)
    }
  }

  func testEncodeDecode() {
    let selection = Selection(sel:BB.OUT, index:99)
    let lst:[BB] = [BB.OUT, BB.SINGLE, BB.DOUBLE, BB.TRIPLE, BB.HOMERUN, BB.ERROR_1B, BB.ERROR_2B]
    for (i,value) in lst.enumerate() {
      let se = Selection(sel:value, index:i)
      
      let stPack = StructPack()
      se.encode(stPack)
      let nsdata:NSData = stPack.getData()
      
      let stUnpack = StructUnpack(nsdata:nsdata)
      selection.decode(stUnpack)
      XCTAssert(se == selection)
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

//
//  SideRetiredDataTest.swift
//  BBGame
//
//  Created by Steven Journeay on 10/31/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import XCTest
@testable import BBGame

class SideRetiredDataTest: XCTestCase {
    
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
    
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func encodeDecodeVerify(srd:SideRetiredData) {
    // encode and decode and verify match
    let stPack = StructPack()
    srd.encode(stPack)
    
    let nsdata:NSData = stPack.getData()
    
    let stUnpack = StructUnpack(nsdata:nsdata)
    let srd2 = SideRetiredData()
    srd2.decode(stUnpack)
    XCTAssert(srd == srd2)
  }
  
  func testCreate() {
    let srd = SideRetiredData()
    XCTAssertEqual(srd.runs, 0)
    XCTAssertEqual(srd.hits, 0)
    XCTAssertEqual(srd.errors, 0)
    XCTAssertEqual(srd.lob, 0)
  }
    
  func testClear() {
    let srd = SideRetiredData()
    srd.runs = 5
    srd.hits = 10
    srd.errors = 3
    srd.lob = 100

    srd.clear()
    XCTAssertEqual(srd.runs, 0)
    XCTAssertEqual(srd.hits, 0)
    XCTAssertEqual(srd.errors, 0)
    XCTAssertEqual(srd.lob, 0)
  }
  
  func testEncodeDecode() {
    let srd = SideRetiredData()
    
    encodeDecodeVerify(srd)
    srd.runs += 1
    encodeDecodeVerify(srd)
    srd.hits += 10
    encodeDecodeVerify(srd)
    srd.errors += 2
    encodeDecodeVerify(srd)
    srd.lob += 20
    encodeDecodeVerify(srd)
  }

  func testEqualNotEqual() {
    let srd1 = SideRetiredData()
    let srd2 = SideRetiredData()
    let srd3 = SideRetiredData()
    
    XCTAssert(srd1 == srd2)
    XCTAssert(srd1 == srd3)
    XCTAssert(srd2 == srd3)

    srd2.runs += 1
    
    XCTAssert(srd1 != srd2)
    XCTAssert(srd1 == srd3)
    XCTAssert(srd2 != srd3)
    
    srd1.hits = 4

    XCTAssert(srd1 != srd2)
    XCTAssert(srd1 != srd3)
    XCTAssert(srd2 != srd3)
    
    srd3.hits = 4
    
    XCTAssert(srd1 != srd2)
    XCTAssert(srd1 == srd3)
    XCTAssert(srd2 != srd3)
    
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

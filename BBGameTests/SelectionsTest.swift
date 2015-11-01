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
  
  func FilterSelections(lst:[Selection], what:BB) -> [Selection] {
    var lst2:[Selection] = []
    for sel in lst where sel.sel == what {
      lst2.append(sel)
    }
    return lst2
  }
  
  func testGenerateDefaultValues() {
    let lst = generate_selections(createFunc: CreateSelection)
    XCTAssertEqual(FilterSelections(lst, what:BB.HOMERUN).count, 5)
    XCTAssertEqual(FilterSelections(lst, what:BB.TRIPLE).count, 5)
    XCTAssertEqual(FilterSelections(lst, what:BB.DOUBLE).count, 10)
    XCTAssertEqual(FilterSelections(lst, what:BB.SINGLE).count, 20)
    XCTAssertEqual(FilterSelections(lst, what:BB.OUT).count, 60)
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

  func enocdeDecodeVerify(se:Selection) {
    let stPack = StructPack()
    se.encode(stPack)
    let nsdata:NSData = stPack.getData()
    
    let stUnpack = StructUnpack(nsdata:nsdata)
    let selection = Selection(stUnpack:stUnpack)
    XCTAssert(se == selection)
  }
  
  func testEncodeDecode() {

    let home = Team(name:"Home", home: true, robot:false, tla:"HOM")
    // let visitor = Team(name: "Visitor", home: false, robot: false, tla: "VIS")

    let lst:[BB] = [BB.OUT, BB.SINGLE, BB.DOUBLE, BB.TRIPLE, BB.HOMERUN, BB.ERROR_1B, BB.ERROR_2B]
    for (i,value) in lst.enumerate() {
      let se = Selection(sel:value, index:i)
      
      enocdeDecodeVerify(se)
      se.Used(home)
      enocdeDecodeVerify(se)
      
    }
  }
  
  func testEqualNotEqual() {
    let sel1 = Selection(sel:BB.OUT, index:0)
    let sel2 = Selection(sel:BB.SINGLE, index:1)
    let sel3 = Selection(sel:BB.OUT, index:0)
    
    let team1 = Team(name:"Aces")
    XCTAssert(sel1 != sel2)
    XCTAssert(sel1 == sel3)
    sel1.Used(team1)

    XCTAssert(sel1 != sel2)
    XCTAssert(sel1 != sel3)
    sel3.Used(team1)
    
    XCTAssert(sel1 != sel2)
    XCTAssert(sel1 == sel3)
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

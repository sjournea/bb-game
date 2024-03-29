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
  
  func testByteUtils() {
    let lstFloats:[Float] = [10.0, 11.0, -1.2, 100.457, 1729.1729]
    for testValue in lstFloats {
      let bytes = toByteArray(testValue)
      let value = fromByteArray(bytes, Float.self)
      XCTAssertEqual(testValue, value)
    }
    let lstDoubles:[Double] = [10.0, 11.0, -1.2, 100.457, 1729.1729, 45.0e9, -32.6789e-9]
    for testValue in lstDoubles {
      let bytes = toByteArray(testValue)
      let value = fromByteArray(bytes, Double.self)
      XCTAssertEqual(testValue, value)
    }
    
  }
  
  func testUInt8() {
    let testValues:[UInt] = [1,5,10,100,255]
    for testValue in testValues {
      print("Testing UInt8 \(testValue)")
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
  }
  
  func testInt8() {
    let testValues:[Int] = [-120, -10, 0, 1,5,10,100]
    for testValue in testValues {
      print("Testing Int8 \(testValue)")
      // pack a byte
      let nsdata:NSData = Struct.pack("b", values:[testValue])
      XCTAssert(nsdata.length == 1)
      
      // unpack a byte
      let udata:[AnyObject] = Struct.unpack("b", data:nsdata)
      XCTAssert(udata.count == 1)
      if udata.count > 0 {
        if let value = udata[0] as? Int {
          XCTAssert(value == testValue)
        } else {
          XCTAssert(false, "value is not a Int")
        }
      }
    }
  }

  func testUInt16() {
    let testValues:[UInt] = [1,5,100, 1000, 2000, 5555]
    for testValue in testValues {
      print("Testing UInt16 \(testValue)")
      // pack a UInt16
      let nsdata:NSData = Struct.pack("H", values:[testValue])
      XCTAssert(nsdata.length == 2)
      
      // unpack a UInt16
      let udata:[AnyObject] = Struct.unpack("H", data:nsdata)
      XCTAssert(udata.count == 1)
      if udata.count > 0 {
        if let value = udata[0] as? UInt {
          XCTAssert(value == testValue)
        } else {
          XCTAssert(false, "value is not a Uint")
        }
      }
    }
  }

  func testInt16() {
    let testValues:[Int] = [-1000, -1, 0, 1, 5, 100, 1000, 2000, 5555, 20000]
    for testValue in testValues {
      print("Testing Int16 \(testValue)")
      // pack a Int16
      let nsdata:NSData = Struct.pack("h", values:[testValue])
      XCTAssert(nsdata.length == 2)
      
      // unpack a Int16
      let udata:[AnyObject] = Struct.unpack("h", data:nsdata)
      XCTAssert(udata.count == 1)
      if udata.count > 0 {
        if let value = udata[0] as? Int {
          XCTAssert(value == testValue)
        } else {
          XCTAssert(false, "value is not a Int")
        }
      }
    }
  }

  func testFloat() {
    let testValues:[Float] = [10.0, -1.0, 0.9, 1001.0, 3.1549]
    for testValue in testValues {
      print("Testing Float \(testValue)")
      // pack a String
      let nsdata:NSData = Struct.pack("f", values:[testValue])
      XCTAssert(nsdata.length == 4)
      
      // unpack a String
      let udata:[AnyObject] = Struct.unpack("f", data:nsdata)
      XCTAssert(udata.count == 1)
      if udata.count > 0 {
        if let value = udata[0] as? Float {
          XCTAssert(value == testValue)
        } else {
          XCTAssert(false, "value is not a Float")
        }
      }
    }
  }
    
  func testString() {
    let testValues:[String] = ["Hello", "World!"]
    for testValue in testValues {
      print("Testing String \(testValue)")
      // pack a String
      let nsdata:NSData = Struct.pack("s", values:[testValue])
      XCTAssert(nsdata.length == testValue.utf8.count + 1)
            
      // unpack a String
      let udata:[AnyObject] = Struct.unpack("s", data:nsdata)
      XCTAssert(udata.count == 1)
      if udata.count > 0 {
        if let value = udata[0] as? String {
          XCTAssert(value == testValue)
        } else {
          XCTAssert(false, "value is not a String")
        }
      }
    }
  }

  func testBool() {
    let testValues:[Bool] = [true, false]
    for testValue in testValues {
      print("Testing Bool \(testValue)")
      // pack a byte
      let nsdata:NSData = Struct.pack("?", values:[testValue])
      XCTAssert(nsdata.length == 1)
      
      // unpack a byte
      let udata:[AnyObject] = Struct.unpack("?", data:nsdata)
      XCTAssert(udata.count == 1)
      if udata.count > 0 {
        if let value = udata[0] as? Bool {
          XCTAssert(value == testValue)
        } else {
          XCTAssert(false, "value is not a Bool")
        }
      }
    }
  }

  func testMultiple() {
    let b:Bool = true
    let u8:UInt = 10
    let u16:UInt = 20
    // pack data
    let nsdata:NSData = Struct.pack(">HB?", values:[u16, u8, b])
    XCTAssert(nsdata.length == 4)
      
    // unpack a byte
    let udata:[AnyObject] = Struct.unpack(">HB?", data:nsdata)
    XCTAssert(udata.count == 3)

    if udata.count > 0 {
      let u16_2 = udata[0] as? UInt
      XCTAssert(u16 == u16_2)
    }
    if udata.count > 1 {
      let u8_2 = udata[1] as? UInt
      XCTAssert(u8 == u8_2)
    }
    if udata.count > 2 {
      let b_2 = udata[2] as? Bool
      XCTAssert(b == b_2)
    }
    
  }

  func testMultiplePacks() {
    let version:UInt = 1
    let b:Bool = true
    let u8:UInt = 10
    let u16:UInt = 20

    // pack data, 2 packs
    let stPack = StructPack()
    
    stPack.pack("B", values: [version])
    stPack.pack(">HB?", values: [u16, u8, b])
    let nsdata:NSData = stPack.getData()
    XCTAssert(nsdata.length == 5)
    
    // unpack data, 2 unpacks
    let stUnpack = StructUnpack(nsdata:nsdata)
    var udata:[AnyObject] = stUnpack.unpack("B")
    XCTAssert(udata.count == 1)
    if udata.count > 0 {
      let ver_2 = udata[0] as? UInt
      XCTAssert(ver_2 == version)
    }
    
    udata = stUnpack.unpack(">HB?")
    XCTAssert(udata.count == 3)
    
    if udata.count > 0 {
      let u16_2 = udata[0] as? UInt
      XCTAssert(u16 == u16_2)
    }
    if udata.count > 1 {
      let u8_2 = udata[1] as? UInt
      XCTAssert(u8 == u8_2)
    }
    if udata.count > 2 {
      let b_2 = udata[2] as? Bool
      XCTAssert(b == b_2)
    }
    
  }
  
  func testCounter() {
    let testData:[UInt] = [10,20,30,40,1000]
    
    // pack data
    let stPack = StructPack()
    
    stPack.pack(">5H", values: [testData[0], testData[1], testData[2], testData[3], testData[4]])
    let nsdata:NSData = stPack.getData()
    XCTAssert(nsdata.length == 10)
    
    // unpack data
    let stUnpack = StructUnpack(nsdata:nsdata)
    var udata:[AnyObject] = stUnpack.unpack(">5H")
    XCTAssert(udata.count == 5)
    for (n,tData) in testData.enumerate() {
      let td = udata[n] as? UInt
      XCTAssert(td == tData)
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

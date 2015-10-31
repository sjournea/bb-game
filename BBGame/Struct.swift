//
//  Struct.swift
//  BBGame
//
//  Created by Steven Journeay on 10/30/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation

enum Endian {
    case little
    case big
}

enum Ops:Int {
  case Stop = 1
  case SetNativeEndian
  case SetLittleEndian
  case SetBigEndian
  case SetNetworkEndian
  
  case VarUInt8 = 11
  case VarInt8
  case VarUInt16
  case VarBool

  func isControlOp() -> Bool {
    return self.rawValue <= 10
  }

  func isVarOp() -> Bool {
    return self.rawValue > 10
  }
}

class StructImpl {
  // base class for all Struct operations; Pack and Unpack
  var format:String = ""
  var opStream:[Ops] = []
  var endian:Endian = .big
  
  init() {}
  
  private func parseFormat() {
    var repeatCount = 0
    opStream.removeAll()
  
    for ch in self.format.characters {
      // Check for integers, these are repeat counts
      if let value = Int(String(ch)) {
        repeatCount = repeatCount*10 + value
        continue
      }
      
      if repeatCount == 0 {
        // Check for control characters
        switch ch {
        case ">": opStream.append(.SetBigEndian)
        case "<": opStream.append(.SetLittleEndian)
        case "!": opStream.append(.SetNetworkEndian)
        default:
          repeatCount = 1
        }
      }
      
      if repeatCount > 0 {
        for var i = 0; i < repeatCount; ++i {
          switch ch {
          case "B": opStream.append(.VarUInt8)
          case "b": opStream.append(.VarInt8)
          case "H": opStream.append(.VarUInt16)
          case "?": opStream.append(.VarBool)
          default:
            print("ERROR parseFormat() bad character in format: \"\(ch)\"")
          }
        }
      }
      // reset repeat count
      repeatCount = 0
    }
    opStream.append(.Stop)
  }
  
  func process() {
    for op in opStream {
      switch op {
      case .SetBigEndian: cbSetBigEndian()
      case .SetLittleEndian: cbSetLittleEndian()
      case .SetNativeEndian: cbSetNativeEndian()
      case .SetNetworkEndian: cbSetNetworkEndian()
      case .VarUInt8: cbVarUInt8()
      case .VarInt8: cbVarInt8()
      case .VarUInt16: cbVarUInt16()
      case .VarBool: cbVarBool()
      case .Stop: cbStop()
      }
    }
  }

  // callbacks that can override
  func cbSetLittleEndian() {
    endian = .little
  }
  
  func cbSetBigEndian() {
    endian = .big
  }
  func cbSetNetworkEndian() {
    endian = .big
  }
  
  func cbSetNativeEndian() {
    endian = .big
    // TODO -- natve order on iPhone
    // let byteOrder = CFByteOrderGetCurrent()
    // endian = byteOrder & CFByteOrderBigEndian ? .big : .little
  }
  
  func cbStop() {}
  
  // below funcs MUST be overriden by Pack and Unpack
  func cbVarUInt8() {
    print("cbVarUInt8() NOT SUPPORTED")
  }
  
  func cbVarInt8() {
    print("cbVarInt8() NOT SUPPORTED")
  }

  func cbVarUInt16() {
    print("cbVarUInt16() NOT SUPPORTED")
  }

  func cbVarBool() {
    print("cbVarBool() NOT SUPPORTED")
  }

}

class StructPack : StructImpl {
  var input:[AnyObject]?
  var index:Int = 0
  var bytes:[UInt8] = []

  func pack(format:String, values:[AnyObject]) {
    self.format = format
    self.input = values
    parseFormat()
    index = 0
    process()
  }
  
  override func cbVarUInt8() {
    if let value = input![index++] as? UInt {
      if value > 0xFF {
        print("ERROR - UInt8 value:\(value) out of range")
      } else {
        bytes.append(UInt8(value))
      }
    } else {
      print( "ERROR - cannot convert value to UInt")
    }
  }
  
  override func cbVarInt8() {
    if let value = input![index++] as? Int {
      if value < Int(INT8_MIN) || value > Int(INT8_MAX) {
        print("ERROR - UInt8 value:\(value) out of range")
      } else {
        // let i8 = value as! Int8
        bytes.append(UInt8(bitPattern:Int8(value)))
      }
    } else {
      print( "ERROR - cannot convert value to Int")
    }
  }

  override func cbVarUInt16() {
    if let value = input![index++] as? UInt {
      if value > 0xFFFF {
        print("cbVarUInt16() fail - UInt16 value:\(value) out of range")
      } else {
        // big endian hard wired
        bytes.append(value.hiByte())
        bytes.append(value.loByte())
      }
    } else {
      print( "ERROR - cannot convert value to UInt")
    }
  }

  override func cbVarBool() {
    if let value = input![index++] as? UInt {
      if value == 0 {
        bytes.append(UInt8(0))
      } else {
        bytes.append(UInt8(1))
      }
    } else {
      print( "pack cbVarBool() Fail - cannot convert value to UInt")
    }
  }
  
  func getData() -> NSData {
    return NSData(bytes:bytes, length:bytes.count)
  }

}

class StructUnpack : StructImpl {

  var values:[AnyObject] = []
  var index:Int = 0
  var nsdata:NSData?
  
  init(nsdata:NSData) {
    super.init()
    self.nsdata = nsdata
    index = 0
  }
  
  func unpack(format:String) -> [AnyObject] {
    self.format = format
    parseFormat()
    values.removeAll()
    process()
    return values
  }
  
  private func readBytes(count:Int) -> [UInt8] {
    var bytes:[UInt8] = []
    if index + count > nsdata!.length {
      print( "ERROR readBytes() fail - not enough data")
    } else {
      let ptr = UnsafePointer<UInt8>(nsdata!.bytes)
      let unsafeArray = UnsafeBufferPointer<UInt8>(start:ptr+index, count:count)
      index += count
      for byte in unsafeArray {
        bytes.append(byte)
      }
    }
    return bytes
  }
    
  override func cbVarUInt8() {
    let bytes = readBytes(1)
    values.append(Int(bytes[0]))
  }
  
  override func cbVarInt8() {
    let bytes = readBytes(1)
    let i8:Int8 = Int8(bitPattern:UInt8(bytes[0]))
    values.append(Int(i8))
  }
  
  override func cbVarUInt16() {
    let bytes:[UInt8] = readBytes(2)
    
    var value:UInt = 0
    for byte in bytes {
      value <<= 8
      value |= UInt(byte)
    }
    values.append(value)
  }

  override func cbVarBool() {
    let bytes = readBytes(1)
    let value:Bool = bytes[0] != 0 ? true : false
    values.append(value)
  }
}

class Struct {

  class func pack(format:String, values:[AnyObject]) -> NSData {
    let st = StructPack()
    st.pack(format, values:values)
    return st.getData()
  }
  
  class func unpack(format:String, data:NSData) -> [AnyObject] {
    let st = StructUnpack(nsdata: data)
    return st.unpack(format)
  }
}

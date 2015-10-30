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

enum Ops {
  case Stop
  //case PackChar
  //case PackInt8
  //case PackInt16
  case varUInt8
  //case PackUInt16
  //case PackString
}

class StructImpl {
  // base class for all Struct operations; Pack and Unpack
  var format:String
  var opStream:[Ops] = []
  
  let bytesForOps:[Ops:Int] = [
    .varUInt8 : 1
  ]
  
  init(format:String) {
    self.format = format
    parseFormat()
  }
  
  private func parseFormat() {
    var repeatCount = 0
    opStream.removeAll()
  
    for ch in self.format.characters {
      // Check for integers, these are repeat counts
      if let value = Int(String(ch)) {
        repeatCount = repeatCount*10 + value
        continue
      }
      
      if repeatCount == 0 { repeatCount = 1 }
      for var i = 0; i < repeatCount; ++i {
        switch ch {
        case "B": opStream.append(.varUInt8)
        default:
          print("bad character in format: \"\(ch)\"")
        }
      }
      // reset repeat count
      repeatCount = 0
    }
    opStream.append(.Stop)
  }
}

class StructPack : StructImpl {

  func pack(input:[AnyObject]) -> NSData {
    var bytes:[UInt8] = []
    var index:Int = 0
    
    for op in opStream {
      switch op {
      case .varUInt8:
        if let value = input[index++] as? UInt {
          if value > 0xFF {
            print("ERROR - UInt8 value:\(value) out of range")
          } else {
            bytes.append(UInt8(value))
          }
        } else {
          print( "ERROR - cannot convert value to UInt")
        }
        
      case .Stop:
        break
      
      }
    }
    
    return NSData(bytes:bytes, length:bytes.count)
  }
}

class StructUnpack : StructImpl {

  var values:[AnyObject] = []
  var index:Int = 0
  var nsdata:NSData?

  init(format:String, nsdata:NSData) {
    super.init(format:format)
    self.nsdata = nsdata
  }
  
  private func readBytes(op:Ops) -> [UInt8] {
    var bytes:[UInt8] = []
    if let count = bytesForOps[op] {
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
    } else {
      print( "ERROR readBytes() fail - op:\(op) not set in bytesForOps")
    }
    return bytes
  }
  
  func unpack() -> [AnyObject] {

    for op in opStream {
      let bytes:[UInt8] = readBytes(op)
      switch op {
      case .varUInt8:
        values.append(Int(bytes[0]))
      case .Stop:
        break
      }
    }
    return values
  }
  
}

class Struct {

  class func pack(format:String, values:[AnyObject]) -> NSData {
    let st = StructPack(format:format)
    return st.pack(values)
  }
  
  class func unpack(format:String, data:NSData) -> [AnyObject] {
    let st = StructUnpack(format:format, nsdata: data)
    return st.unpack()
  }
}

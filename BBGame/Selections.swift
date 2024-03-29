//
//  Selections.swift
//  BBGame
//
//  Created by Steven Journeay on 9/29/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation
import GameplayKit

let SELECTIONS_TOTAL:Int = 100
let SELECTIONS_HOME_RUN:Int = 5
let SELECTIONS_TRIPLE:Int = 5
let SELECTIONS_DOUBLE:Int = 10
let SELECTIONS_SINGLE:Int = 20

enum BB: Int, CustomStringConvertible {
  case OUT = 1,
  SINGLE = 11,
  DOUBLE = 12,
  TRIPLE = 13,
  HOMERUN = 14,
  ERROR_1B = 21,
  ERROR_2B = 22
  
  var description : String {
    get {
      switch(self) {
      case OUT: return "OUT"
      case SINGLE: return "1B"
      case DOUBLE: return "2B"
      case TRIPLE: return "3B"
      case HOMERUN: return "HR"
      case ERROR_1B: return "ERROR_1B"
      case ERROR_2B: return "ERROR_2B"
      }
    }
  }
  
  var desc : String {
    get {
      switch(self) {
      case OUT: return "OUT"
      case SINGLE: return "1B"
      case DOUBLE: return "2B"
      case TRIPLE: return "3B"
      case HOMERUN: return "HR"
      case ERROR_1B: return "ERR"
      case ERROR_2B: return "ERR2"
      }
    }
  }
  
  func isOut() -> Bool {
    return self == OUT
  }
  
  func isError() -> Bool {
    return self == BB.ERROR_1B || self == BB.ERROR_2B
  }
  
  func isHit() -> Bool {
    return self == BB.SINGLE || self == BB.DOUBLE || self == BB.TRIPLE || self == BB.HOMERUN
  }
  
  func bases() -> Int {
    switch(self) {
    case SINGLE: return 1
    case ERROR_1B: return 1
    case DOUBLE: return 2
    case ERROR_2B: return 2
    case TRIPLE: return 3
    case HOMERUN: return 4
    default: return 0
    }
  }
  
}

enum BINARY_VERSION:Int {
  case VERSION = 1
}

class Selection {
  let version:BINARY_VERSION = .VERSION
  var sel: BB?
  var index: Int
  var usedBy:Bool = false  // true is home, false is visitor
  var used:Bool = false    // true used, false still not selected
  
  init(sel: BB, index:Int) {
    self.sel = sel
    self.index = index
  }
  
  init(stUnpack:StructUnpack) {
    sel = BB.OUT
    index = -1
    decode(stUnpack)
  }
  
  var desc : String {
    get {
      return sel!.desc
    }
  }

  func isUsed() -> Bool {
    return self.used
  }
  
  func Used(team:Team) {
    usedBy = team.home
    used = true
  }
  
  func status() -> String {
    return "sel:\(sel) used:\(used)"
  }
  
  func encode(st:StructPack) {
    // version UInt8
    st.pack("B", values:[version.rawValue])
    // idx UInt16
    // sel UInt8
    // used bool
    // usedBy bool
    st.pack(">HB??", values:[index,sel!.rawValue, used, usedBy])
  }
  
  func decode(st:StructUnpack) {
    var values:[AnyObject] = st.unpack("B")
    let decode_version = values[0] as! UInt

    if decode_version == 1 {
      values = st.unpack(">HB??")
      index = values[0] as! Int
      let rawValue = values[1] as! Int
      self.sel = BB(rawValue: rawValue)
      used = values[2] as! Bool
      usedBy = values[3] as! Bool
    }
  }
  
  func str() -> String {
    return "sel:\(sel!.description)"
  }
}

func ==(left:Selection, right:Selection) -> Bool {
  return left.version == right.version &&
         left.index   == right.index &&
         left.sel!    == right.sel! &&
         left.used    == right.used &&
         left.usedBy  == right.usedBy
}

func !=(left:Selection, right:Selection) -> Bool {
  return !(left == right)
}

typealias CreateSelectionFuncType = (Int, BB) -> Selection

func CreateSelection(index:Int, bb:BB) -> Selection {
    return Selection(sel:bb, index:index)
}

func generate_selections(total:Int=SELECTIONS_TOTAL,
                         NUM_HR:Int=SELECTIONS_HOME_RUN,
                         NUM_3B:Int=SELECTIONS_TRIPLE,
                         NUM_2B:Int=SELECTIONS_DOUBLE,
                         NUM_1B:Int=SELECTIONS_SINGLE,
                         createFunc: CreateSelectionFuncType) ->[Selection] {
  var lstSelections:[Selection] = []
  
  for var i = 0; i < total; ++i {
    lstSelections.append(createFunc(i, BB.OUT))
  }

  let shuffled = GKShuffledDistribution(lowestValue: 0, highestValue: total-1)
  var setIndex = Set<Int>()

  for _ in 1...NUM_HR {
    let idx:Int = shuffled.nextInt()
    assert(setIndex.contains(idx) == false)
    setIndex.insert(idx)
    lstSelections[idx].sel = BB.HOMERUN
  }
  
  for _ in 1...NUM_3B {
    let idx:Int = shuffled.nextInt()
    assert(setIndex.contains(idx) == false)
    setIndex.insert(idx)
    lstSelections[idx].sel = BB.TRIPLE
  }
  
  for _ in 1...NUM_2B {
    let idx:Int = shuffled.nextInt()
    assert(setIndex.contains(idx) == false)
    setIndex.insert(idx)
    lstSelections[idx].sel = BB.DOUBLE
  }
  
  for _ in 1...NUM_1B {
    let idx:Int = shuffled.nextInt()
    assert(setIndex.contains(idx) == false)
    setIndex.insert(idx)
    lstSelections[idx].sel = BB.SINGLE
  }

  return lstSelections
}

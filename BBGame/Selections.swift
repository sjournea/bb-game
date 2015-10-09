//
//  Selections.swift
//  BBGame
//
//  Created by Steven Journeay on 9/29/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation
import GameplayKit

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
  
  func isOut() -> Bool {
    return self == OUT
  }
  
  func isError() -> Bool {
    return self == BB.ERROR_1B || self == BB.ERROR_2B
  }
  
  func isHit() -> Bool {
    return self == BB.SINGLE || self == BB.DOUBLE || self == BB.TRIPLE || self == BB.HOMERUN
  }
}

enum BINARY_VERSION:Int {
  case VERSION = 1
}

class Selection {
  let idx: Int
  var sel: BB
  private var _used:Bool = false
  let version = BINARY_VERSION.VERSION
  
  init(idx: Int, sel: BB) {
    self.idx = idx
    self.sel = sel
  }
  
  func isUsed() -> Bool {
    return self._used
  }
  
  func used() {
    self._used = true
  }
  
  func status() -> String {
    return "idx:\(idx) sel:\(self.sel) used:\(self._used)"
  }
  
  func encode(version:BINARY_VERSION) -> [Int] {
    assert(true, "encode() not implemented")
    return []
  }
  
  func decode(bin_data:[UInt8]) {
    assert(true, "decode() not implemented")
  }
  
  func str() -> String {
    return "idx:\(self.idx) sel:\(self.sel.description)"
  }
}

func ==(left:Selection, right:Selection) -> Bool {
  return left.version == right.version &&
    left.idx     == right.idx &&
    left.sel     == right.sel &&
    left._used   == right._used
}

func !=(left:Selection, right:Selection) -> Bool {
  return !(left == right)
}

func generate_selections(total:Int=100, NUM_HR:Int=5, NUM_3B:Int=5, NUM_2B:Int=10, NUM_1B:Int=20) ->[Selection] {
  var selection:Selection
  var lstSelections = [Selection]()
  var setIndex = Set<Int>()
  
  // (TODO) Add usage of GkShuffledDistribution
  for x in 0..<total {
    selection = Selection(idx:x, sel:BB.OUT)
    lstSelections.append(selection)
  }
  
  for _ in 1...NUM_HR {
    var idx:Int = Int(arc4random_uniform(UInt32(total)))
    while setIndex.contains(idx) {
      idx++
      if idx == Int(total) { idx = 0 }
    }
    setIndex.insert(idx)
    lstSelections[idx].sel = BB.HOMERUN
  }
  
  for _ in 1...NUM_3B {
    var idx:Int = Int(arc4random_uniform(UInt32(total)))
    while setIndex.contains(idx) {
      idx++
      if idx == Int(total) { idx = 0 }
    }
    setIndex.insert(idx)
    lstSelections[idx].sel = BB.TRIPLE
  }
  
  for _ in 1...NUM_2B {
    var idx:Int = Int(arc4random_uniform(UInt32(total)))
    while setIndex.contains(idx) {
      idx++
      if idx == Int(total) { idx = 0 }
    }
    setIndex.insert(idx)
    lstSelections[idx].sel = BB.DOUBLE
  }
  for _ in 1...NUM_1B {
    var idx:Int = Int(arc4random_uniform(UInt32(total)))
    while setIndex.contains(idx) {
      idx++
      if idx == Int(total) { idx = 0 }
    }
    setIndex.insert(idx)
    lstSelections[idx].sel = BB.SINGLE
  }
  return lstSelections
}

class SelectionGenerator: GeneratorType {
  private var selections: [Selection]      // collection to be iterated
  private var nextIndex: Int          // Hold the index of the next iteration
  
  init(selections: [Selection]) {
    self.selections = selections
    self.nextIndex = 0
  }
  
  func next() -> Selection? {
    if (self.nextIndex > self.selections.count - 1) {
      return nil
    }
    return self.selections[self.nextIndex++]
  }
}

class SelectionList: SequenceType {
  let version = BINARY_VERSION.VERSION
  var lst:[Selection] = []
  private var _next = 0
  
  func generate() -> SelectionGenerator {
    return SelectionGenerator(selections:lst)
  }
  
  func generate_list(total:Int=100, NUM_HR:Int=5, NUM_3B:Int=5, NUM_2B:Int=10, NUM_1B:Int=20) {
    self.lst = generate_selections(total, NUM_HR:NUM_HR, NUM_3B:NUM_3B, NUM_2B:NUM_2B, NUM_1B:NUM_1B)
  }
  
  init(generate_now:Bool=false) {
    if generate_now {
      self.generate_list()
    }
  }
  
  var count : Int {
    get {  return self.lst.count }
  }
  
  func get_item(index:Int) -> Selection {
    return self.lst[index]
  }
  
  //    func iter() -> Selection {
  //        assert(self._next < self.count, "iter() overload in SelectionList")
  //        return self.lst[self._next++]
  //   }
  
  func encode(version:BINARY_VERSION) -> [Int] {
    assert(true, "encode() not implemented")
    return []
  }
  
  func decode(bin_data:[UInt8]) {
    assert(true, "decode() not implemented")
  }
}

func ==(left:SelectionList, right:SelectionList) -> Bool {
  if left.version == right.version &&
    left.count   == right.count {
      for var i = 0; i < left.count; ++i {
        if left.lst[i] != right.lst[i] {
          return false
        }
      }
      return true
  }
  return false
}

func !=(left:SelectionList, right:SelectionList) -> Bool {
  return !(left == right)
}


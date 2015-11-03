//
//  SideRetiredData.swift
//  BBGame
//
//  Created by Steven Journeay on 11/3/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation
class SideRetiredData {
  var runs:Int = 0
  var hits:Int = 0
  var errors:Int = 0
  var lob:Int = 0
  
  func clear() {
    self.runs = 0
    self.hits = 0
    self.errors = 0
    self.lob = 0
  }
  
  func encode(stPack:StructPack) {
    // TODO Need version here?
    stPack.pack(">4H", values:[runs, hits, errors, lob])
  }
  
  func decode(stUnPack:StructUnpack) {
    let values = stUnPack.unpack(">4H")
    runs = values[0] as! Int
    hits = values[1] as! Int
    errors = values[2] as! Int
    lob = values[3] as! Int
  }
  
  func makeDict() -> [String:Int] {
    return ["runs":self.runs, "hits":self.hits, "errors":self.errors, "lob":self.lob]
  }
  
  func str() -> String {
    return "Runs:\(self.runs) Hits:\(self.hits) Errors:\(self.errors) LOB:\(self.lob)"
  }
}

func ==(left:SideRetiredData, right:SideRetiredData) -> Bool {
  return (left.runs   == right.runs &&
    left.hits   == right.hits &&
    left.errors == right.errors &&
    left.lob    == right.lob)
}

func !=(left:SideRetiredData, right:SideRetiredData) -> Bool {
  return !(left == right)
}


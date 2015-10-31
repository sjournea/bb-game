//
//  Team.swift
//  BBGame
//
//  Created by Steven Journeay on 9/29/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation

class Team {
  let version = BINARY_VERSION.VERSION
  let TEAM_NAME_LENGTH = 20
  var name:String
  var tla:String
  var robot:Bool = false
  // private var _id
  var runs = 0
  var lob = 0
  var hits = 0
  var errors = 0
  var innings:[Int] = []
  var lstSelections:[[Int]] = []
  var lastSelections:[Int] = []
  var home:Bool = false
  
  private func _clear_data() {
    runs = 0
    lob = 0
    hits = 0
    errors = 0
    innings = []
    lstSelections = []
    lastSelections = []
  }
  
  init(name:String="", home:Bool=false, robot:Bool=false, tla:String="") {
    self.name = name
    self.home = home
    self.robot = robot
    self.tla = tla
    self._clear_data()
  }
  
  func start_game() {
    self._clear_data()
  }
  
  func addSelection(idx:Int) {
    self.lastSelections.append(idx)
  }
  
  func at_bat(cnt:Int=0) {
    self.innings.append(cnt)
    self.lstSelections.append(self.lastSelections)
    self.lastSelections = []
  }
  
  func score(runs:Int=1) {
    self.runs += runs
    let val = self.innings[self.innings.endIndex-1]
    self.innings[self.innings.endIndex-1] = val + runs
  }
  
  func encode(stPack:StructPack ) {
    // version UInt8
    stPack.pack("B", values:[version.rawValue])
    // object id  12s     (database)
    // robot      bool
    // runs       UInt16
    // hits       UInt16
    // errors     UInt16
    // lob        UInt16
    stPack.pack(">?4H", values:[robot, runs, hits, errors, lob])
    // numInnings UInt8
    // innings    [Int16]
    // selections [[Int]] -- for each inning
    stPack.pack("B", values:[innings.count])
    for (n,inning_score) in innings.enumerate() {
      stPack.pack(">h", values:[inning_score])
      let lst:[Int] = lstSelections[n]
      stPack.pack("B", values:[lst.count])
      for idx in lst {
        stPack.pack("B", values:[idx])
      }
    }
    // name       s
    stPack.pack("ss", values:[name, tla])
  }
  
  func decode(stUnPack:StructUnpack) {
    // version UInt8
    var values:[AnyObject] = stUnPack.unpack("B")
    let decode_version = values[0] as! UInt
    
    if decode_version == 1 {
      // object id  12s     (database)
      // robot      bool
      // runs       UInt16
      // hits       UInt16
      // errors     UInt16
      // lob        UInt16
      values = stUnPack.unpack(">?4H")
      robot = values[0] as! Bool
      runs = values[1] as! Int
      hits = values[2] as! Int
      errors = values[3] as! Int
      lob = values[4] as! Int
      
      // numInnings UInt8
      // innings    [Int16]
      // selections [[Int]] -- for each inning
      values = stUnPack.unpack("B")
      let numInnings = values[0] as! Int
      innings.removeAll()
      lstSelections.removeAll()
      for _ in 0..<numInnings {
        values = stUnPack.unpack(">h")
        let val = values[0] as! Int
        innings.append(val)
        values = stUnPack.unpack("B")
        let cnt = values[0] as! Int
        var lst:[Int] = []
        for _ in 0..<cnt {
          values = stUnPack.unpack("B")
          let idx = values[0] as! Int
          lst.append(idx)
        }
        lstSelections.append(lst)
      }
      // name       s
      // tla        s
      values = stUnPack.unpack("ss")
      name = values[0] as! String
      tla = values[1] as! String
    }
  }
  
  func isVisitor() -> Bool {
    return !home
  }
  
  func isHome() -> Bool {
    return home
  }

  func isRobot() -> Bool {
    return robot
  }
  
  func isHuman() -> Bool {
    return !robot
  }
  
  func str() -> String {
    return self.name
  }
}

func ==(left:Team, right:Team) -> Bool {
  return left.version == right.version &&
    //left._id  == right._id &&
    left.name == right.name &&
    left.runs == right.runs &&
    left.hits == right.hits &&
    left.errors == right.errors &&
    left.robot == right.robot &&
    left.lstSelections == right.lstSelections &&
    left.tla == right.tla
}

func !=(left:Team, right:Team) -> Bool {
  return !(left == right)
}

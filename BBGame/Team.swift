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
  
  init(name:String="", home:Bool=false, robot:Bool=false) {
    self.name = name
    self.home = home
    self.robot = robot
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
  
  func encode(version:BINARY_VERSION) -> [Int] {
    assert(true, "encode() not implemented")
    return []
  }
  
  func decode(bin_data:[UInt8]) {
    assert(true, "decode() not implemented")
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
    left.lstSelections == right.lstSelections
}

func !=(left:Team, right:Team) -> Bool {
  return !(left == right)
}

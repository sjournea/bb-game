//
//  BBGame.swift
//  BBGame
//
//  Created by Steven Journeay on 9/29/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation

class BBGame : Game {
  var gameOver:Bool = true
  var inning = 1
  var half = "Top"
  var up:Team?
  var atBat: Team?
  var selection:Selection?
  var selectionIndex = 0
  var outs = 0
  var error = ""
  var dctRunnerAdvance:[String:AnyObject] = [:]
  var runs = 0
  var srd_runs = 0
  var srd_hits = 0
  var srd_errors = 0
  var srd_lob = 0
  var batterResult = ""
  var nextEvent = "To Start Game"
  var makeSelection = false
  var sideRetired = false
  
  override func evtGameStart(dct:[String:AnyObject] = [:]) -> Int {
    print("evtGameStart() dct:\(dct)")
    gameOver = false
    return EVENT_CONTINUE
  }
  
  override func evtGameEnd(dct:[String:AnyObject] = [:]) -> Int {
    print("evtGameEnd() dct:\(dct)")
    gameOver = true
    nextEvent = "To Start Game"
    return EVENT_CONTINUE
  }
  
  override func evtInningStart(dct:[String:AnyObject] = [:]) -> Int {
    print("evtInningStart() - dct:\(dct)")
    self.inning = dct["inning"] as! Int
    self.half = dct["half"] as! String
    self.up = dct["up"] as? Team
    outs = 0
    return EVENT_CONTINUE
  }
  
  override func evtAtBat(dct:[String:AnyObject] = [:]) -> Int{
    print("evtAtBat() dct:\(dct)")
    let team = dct["team"] as! Team
    nextEvent = "\(team.name) Batter Up"
    makeSelection = true
    return EVENT_CONTINUE
  }
  
  override func evtSelection(dct:[String:AnyObject] = [:]) -> Int {
    print("evtSelection() dct:\(dct)")
    selection = dct["sel"] as? Selection
    selectionIndex = dct["idx"] as! Int
    batterResult = ""
    runs = 0
    sideRetired = false
    return EVENT_CONTINUE
  }
  
  override func evtOut(dct:[String:AnyObject] = [:]) -> Int {
    print("evtOut() dct:\(dct)")
    batterResult = "Out"
    self.outs = dct["outs"] as! Int
    return EVENT_CONTINUE
  }
  
  override func evtError(dct:[String:AnyObject] = [:]) -> Int {
    print("evtError() dct:\(dct)")
    batterResult = dct["error"] as! String
    return EVENT_CONTINUE
  }
  
  override func evtHit(dct:[String:AnyObject] = [:]) -> Int {
    print("evtHit() dct:\(dct)")
    batterResult = dct["hit"] as! String
    return EVENT_CONTINUE
  }
  
  override func evtRunnerAdvance(dct:[String:AnyObject] = [:]) -> Int {
    print("evtRunnerAdvance() dct:\(dct)")
    dctRunnerAdvance = dct
    return EVENT_CONTINUE
  }
  
  override func evtRun(dct:[String:AnyObject] = [:]) -> Int {
    print("evtRun() dct:\(dct)")
    self.runs = dct["runs"] as! Int
    return EVENT_CONTINUE
  }
  
  override func evtSideRetired(dct:[String:AnyObject] = [:]) -> Int {
    print("evtSideRetired() dct:\(dct)")
    self.srd_runs = dct["runs"] as! Int
    self.srd_hits = dct["hits"] as! Int
    self.srd_errors = dct["errors"] as! Int
    self.srd_lob = dct["lob"] as! Int
    nextEvent = "to continue"
    sideRetired = true
    outs = 0
    return EVENT_CONTINUE
  }
}
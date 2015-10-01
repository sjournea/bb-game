//
//  BBGame.swift
//  BBGame
//
//  Created by Steven Journeay on 9/29/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation
import SpriteKit

enum LabelPosition {
  case Center,
  Left
}

class BBGame : Game {
  var scene:GameScene?
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
  
  init(scene:GameScene ) {
    super.init()
    self.scene = scene
  }

  private func hideLabels() {
    for lblNode in scene!.lstLabels {
      lblNode.hidden = true
    }
  }
  
  private func updateLabelNode(idx:Int, text:String, ham:LabelPosition = LabelPosition.Left ) {
    
    let node = scene!.lstLabels[idx]
    node.text = text
    let yOffset:CGFloat = scene!.size.height - (100.0 + CGFloat(idx)*20.0)
    switch ham {
      case .Left:
        node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        node.position = CGPointMake(30.0, yOffset)
      case .Center:
        node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        node.position = CGPointMake(scene!.size.width/2.0, yOffset)
    }
    node.hidden = false
  }
  
  override func evtGameStart(dct:[String:AnyObject] = [:]) -> Int {

    print("evtGameStart() dct:\(dct)")
    gameOver = false
    
    hideLabels()
    updateLabelNode(0, text:"\(scene!.visitor!.name)", ham:.Center)
    updateLabelNode(1, text:"vs", ham:.Center)
    updateLabelNode(2, text:"\(scene!.home!.name)", ham:.Center)

    scene!.lblGameEvent.text = "Event: GameStart"
    nextEvent = "To Continue"

    return EVENT_RETURN
  }
  
  override func evtGameEnd(dct:[String:AnyObject] = [:]) -> Int {
    print("evtGameEnd() dct:\(dct)")
    gameOver = true

    hideLabels()
    updateLabelNode(0, text:"GAME", ham:.Center)
    updateLabelNode(1, text:"OVER", ham:.Center)

    scene!.lblGameEvent.text = "Event: GameEnd"
    nextEvent = "To Start a new Game"
    return EVENT_RETURN
  }
  
  override func evtInningStart(dct:[String:AnyObject] = [:]) -> Int {
    print("evtInningStart() - dct:\(dct)")
    self.inning = dct["inning"] as! Int
    self.half = dct["half"] as! String
    self.up = dct["up"] as? Team
    outs = 0
    
    hideLabels()
    updateLabelNode(0, text:"\(half) of \(inning) -- \(outs) outs - \(base_status())")

    scene!.lblGameEvent.text = "Event: InningStart"
    nextEvent = "To Continue"

    return EVENT_RETURN
  }
  
  override func evtAtBat(dct:[String:AnyObject] = [:]) -> Int{
    print("evtAtBat() dct:\(dct)")
    let team = dct["team"] as! Team

    makeSelection = true

    hideLabels()
    updateLabelNode(0, text:"\(half) of \(inning) -- \(outs) outs - \(base_status())")

    scene!.lblGameEvent.text = "Event: AtBat"
    nextEvent = "\(team.name) Batter Up"

    return EVENT_RETURN
  }
  
  override func evtSelection(dct:[String:AnyObject] = [:]) -> Int {
    print("evtSelection() dct:\(dct)")
    selection = dct["sel"] as? Selection
    selectionIndex = dct["idx"] as! Int
    
    batterResult = ""
    runs = 0
    sideRetired = false

    hideLabels()
    updateLabelNode(0, text:"\(half) of \(inning) -- \(outs) outs - \(base_status())")

    scene!.lblGameEvent.text = "Event: Selection"
    
    return EVENT_RETURN
  }
  
  override func evtOut(dct:[String:AnyObject] = [:]) -> Int {
    print("evtOut() dct:\(dct)")
    self.outs = dct["outs"] as! Int
    
    batterResult = "Out"
    
    hideLabels()
    updateLabelNode(0, text:"\(half) of \(inning) -- \(outs) outs - \(base_status())")
    updateLabelNode(1, text:"Batter: \(batterResult)")

    scene!.lblGameEvent.text = "Event: Out"
    nextEvent = "To Continue"
    return EVENT_RETURN
  }
  
  override func evtError(dct:[String:AnyObject] = [:]) -> Int {
    print("evtError() dct:\(dct)")
    
    batterResult = dct["error"] as! String
    
    hideLabels()
    updateLabelNode(0, text:"\(half) of \(inning) -- \(outs) outs - \(base_status())")
    updateLabelNode(1, text:"Batter: \(batterResult)")

    scene!.lblGameEvent.text = "Event: Error"
    nextEvent = "To Continue"
    return EVENT_RETURN
  }
  
  override func evtHit(dct:[String:AnyObject] = [:]) -> Int {
    print("evtHit() dct:\(dct)")
    
    batterResult = dct["hit"] as! String
    
    hideLabels()
    updateLabelNode(0, text:"\(half) of \(inning) -- \(outs) outs - \(base_status())")
    updateLabelNode(1, text:"Batter: \(batterResult)")

    scene!.lblGameEvent.text = "Event: Hit"
    nextEvent = "To Continue"
    return EVENT_RETURN
  }
  
  override func evtRunnerAdvance(dct:[String:AnyObject] = [:]) -> Int {
    print("evtRunnerAdvance() dct:\(dct)")
    dctRunnerAdvance = dct
    
    hideLabels()
    updateLabelNode(0, text:"\(half) of \(inning) -- \(outs) outs - \(base_status())")
    var i = 1
    if let val = dct["3B"] { updateLabelNode(i++, text:"3B -> \(val)") }
    if let val = dct["2B"] { updateLabelNode(i++, text:"2B -> \(val)") }
    if let val = dct["1B"] { updateLabelNode(i++, text:"1B -> \(val)") }
    if let val = dct["Batter"] { updateLabelNode(i++, text:"Batter -> \(val)") }

    scene!.lblGameEvent.text = "Event: RunnerAdvance"
    nextEvent = "To Continue"
    return EVENT_RETURN
  }
  
  override func evtRun(dct:[String:AnyObject] = [:]) -> Int {
    print("evtRun() dct:\(dct)")
    self.runs = dct["runs"] as! Int

    hideLabels()
    updateLabelNode(0, text:"\(half) of \(inning) -- \(outs) outs - \(base_status())")
    updateLabelNode(1, text:"\(runs) runs scored")

    scene!.lblGameEvent.text = "Event: Run"
    nextEvent = "To Continue"
    return EVENT_RETURN
  }
  
  override func evtSideRetired(dct:[String:AnyObject] = [:]) -> Int {
    print("evtSideRetired() dct:\(dct)")
    self.srd_runs = dct["runs"] as! Int
    self.srd_hits = dct["hits"] as! Int
    self.srd_errors = dct["errors"] as! Int
    self.srd_lob = dct["lob"] as! Int

    hideLabels()
    updateLabelNode(0, text:"\(half) of \(inning) -- \(outs) outs - \(base_status())")
    updateLabelNode(1, text:"Side Retired")
    updateLabelNode(2, text:"\(srd_runs) runs \(srd_hits) hits \(srd_errors) errors \(srd_lob) LOB")

    outs = 0
    
    scene!.lblGameEvent.text = "Event: SideRetured"
    nextEvent = "To Continue"
    return EVENT_RETURN
  }
}
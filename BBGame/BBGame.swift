//
//  BBGame.swift
//  BBGame
//
//  Created by Steven Journeay on 9/29/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation
import SpriteKit

class BBGame : Game {
  let EVENT = EVENT_RETURN  // EVENT_RETURN EVENT_CONTINUE
  
  var scene:GameScene?
  var labels:Labels?
  var labelsBottom:Labels?
  var field:BBField?
  var selectionDisplay:SelectionDisplay?
  var summary:BBSummary?
  
  var gameOver:Bool = true
  var inning = 1
  var half = "Top"
  var outs = 0
  var makeSelection = false
  var runnerAdvanceBases:Int = 0
  
  func setScene(scene:GameScene ) {
    self.scene = scene
    labels = scene.labels
    labelsBottom = scene.labelsBottom
    selectionDisplay = scene.selectionDisplay
    field = scene.field
    summary = scene.summaryDisplay
  }

  private func delayGame(timeSec:Int64 = GAME_DELAY) {

    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), timeSec * Int64(NSEC_PER_SEC))
    dispatch_after(time, dispatch_get_main_queue())
    {
        self.scene!.runGame()
    }
  }
  override func evtGameStart(dct:[String:AnyObject] = [:]) -> Int {

    print("evtGameStart() dct:\(dct)")
    gameOver = false
    
    labels!.hideLabels()
    labels!.updateLabelNode(0, text:"\(scene!.visitor!.name)", ham:.Center)
    labels!.updateLabelNode(1, text:"vs", ham:.Center)
    labels!.updateLabelNode(2, text:"\(scene!.home!.name)", ham:.Center)
    // labels!.color = .whiteColor()

    labelsBottom!.updateLabelNode(0, text:"Event: GameStart", ham:.Center)
    //labelsBottom!.updateLabelNode(1, text:"Tap screen to continue", ham:.Center)

    delayGame()

    return EVENT
  }
  
  override func evtGameFinal(dct:[String:AnyObject] = [:]) -> Int {
    print("evtGameFinal() dct:\(dct)")
    
    labels!.hideLabels()
    labels!.updateLabelNode(0, text:"FINAL", ham:.Center)
    
    let visitor_score = "\(scene!.visitor!.name) \(scene!.visitor!.runs)"
    let home_score = "\(scene!.home!.name) \(scene!.home!.runs)"

    if scene!.visitor!.runs > scene!.home!.runs {
      labels!.updateLabelNode(2, text:visitor_score + " " + home_score, ham:.Center)
      //labels!.color = scene!.visitor!.color!
    } else {
      labels!.updateLabelNode(2, text:home_score + " " + visitor_score, ham:.Center)
      //labels!.color = scene!.home!.color!
    }
    let lob = "LOB: \(scene!.visitor!.name) \(scene!.visitor!.lob), \(scene!.home!.name) \(scene!.home!.lob)"
    labels!.updateLabelNode(3, text:lob, ham:.Center)
    
    
    labelsBottom!.updateLabelNode(0, text:"Event: GameFinal", ham:.Center)
    labelsBottom!.updateLabelNode(1, text:"Tap screen to continue", ham:.Center)

    return EVENT
  }

  override func evtGameEnd(dct:[String:AnyObject] = [:]) -> Int {
    print("evtGameEnd() dct:\(dct)")
    gameOver = true

    /*
    labels!.hideLabels()
    labels!.updateLabelNode(0, text:"GAME", ham:.Center)
    labels!.updateLabelNode(1, text:"OVER", ham:.Center)

    labelsBottom!.updateLabelNode(0, text:"Event: GameEnd", ham:.Center)
    labelsBottom!.updateLabelNode(1, text:"Tap screen to start new game", ham:.Center)
    */
    
    let transition = SKTransition.crossFadeWithDuration(3.0)
    let menuScene = MenuScene(size: scene!.size)
    scene!.view?.presentScene(menuScene, transition: transition)

    return EVENT
  }
  
  override func evtWalkoff(dct:[String:AnyObject] = [:]) -> Int {
    print("evtWalkoff() dct:\(dct)")
    
    labels!.hideLabels()
    labels!.updateLabelNode(0, text:"WALKOFF WIN", ham:.Center)
    
    labelsBottom!.updateLabelNode(0, text:"Event: Walkoff", ham:.Center)
    // labelsBottom!.updateLabelNode(1, text:"Tap screen to continue", ham:.Center)

    delayGame()

    return EVENT
  }
  
  override func evtInningStart(dct:[String:AnyObject] = [:]) -> Int {
    print("evtInningStart() - dct:\(dct)")
    inning = dct["inning"] as! Int
    half = dct["half"] as! String
//    let up = dct["up"] as? BBTeam
    outs = 0
    
    // scoreboard needs to be informed of extra innings
    if half == "top" && inning > _last_inning {
      scene!.scoreboard?.addExtraInning(inning)
    }
    
    labels!.hideLabels()
    labels!.updateLabelNode(0, text:"\(half) of \(inning)", ham:.Center)
    //labels!.color = up!.color!
    
    labelsBottom!.updateLabelNode(0, text:"Event: InningStart", ham:.Center)
    //labelsBottom!.updateLabelNode(1, text:"Tap screen to continue", ham:.Center)

    summary!.inningStart()
    delayGame()

    return EVENT
  }
  
  override func evtAtBat(dct:[String:AnyObject] = [:]) -> Int{
    print("evtAtBat() dct:\(dct)")
    let team = dct["team"] as! BBTeam

    labels!.hideLabels()
    labels!.updateLabelNode(0, text:"\(half) of \(inning)", ham:.Center)

    labelsBottom!.updateLabelNode(0, text:"Event: AtBat", ham:.Center)
    labelsBottom!.updateLabelNode(1, text:"\(team.name)", ham:.Center)


    field!.batterUp()
    if team.isHuman() {
      makeSelection = true
      selectionDisplay!.enableSelection(true)
    } else {
      let idx = team.pickSelection(self)
      self.in_play(idx)
      self.labelsBottom!.hideLabels()
    }
    
    return EVENT
  }
  
  override func evtSelection(dct:[String:AnyObject] = [:]) -> Int {
    print("evtSelection() dct:\(dct)")
    let index = dct["idx"] as! Int
    let sel = dct["sel"] as! Selection
    
    labels!.hideLabels()
    labels!.updateLabelNode(0, text:"\(half) of \(inning)", ham:.Center)
    labels!.updateLabelNode(2, text:"Index:\(index)")
    labels!.updateLabelNode(3, text:"Selection:\(sel.sel)")

    labelsBottom!.updateLabelNode(0, text:"Event: Selection", ham:.Center)
    //labelsBottom!.updateLabelNode(1, text:"Tap screen to continue", ham:.Center)
    
    selectionDisplay!.enableSelection(false)

    delayGame()

    return EVENT
  }
  
  override func evtOut(dct:[String:AnyObject] = [:]) -> Int {
    print("evtOut() dct:\(dct)")
    self.outs = dct["outs"] as! Int
    
    let batterResult = "Out"
    
    labels!.hideLabels()
    labels!.updateLabelNode(0, text:"\(half) of \(inning)", ham:.Center)
    labels!.updateLabelNode(1, text:"Batter: \(batterResult)")

    labelsBottom!.updateLabelNode(0, text:"Event: Out", ham:.Center)
    // labelsBottom!.updateLabelNode(1, text:"Tap screen to continue", ham:.Center)
    
    field!.batterOut()
    summary!.setOuts(self.outs)

    delayGame()

    return EVENT
  }
  
  override func evtError(dct:[String:AnyObject] = [:]) -> Int {
    print("evtError() dct:\(dct)")
    
    let batterResult = dct["error"] as! String
    
    labels!.hideLabels()
    labels!.updateLabelNode(0, text:"\(half) of \(inning)", ham:.Center)
    labels!.updateLabelNode(1, text:"Batter: \(batterResult)")

    labelsBottom!.updateLabelNode(0, text:"Event: Error", ham:.Center)
    //labelsBottom!.updateLabelNode(1, text:"Tap screen to continue", ham:.Center)

    delayGame()

    return EVENT
  }
  
  override func evtHit(dct:[String:AnyObject] = [:]) -> Int {
    print("evtHit() dct:\(dct)")
    
    let batterResult = dct["hit"] as! String
    
    labels!.hideLabels()
    labels!.updateLabelNode(0, text:"\(half) of \(inning)", ham:.Center)
    labels!.updateLabelNode(1, text:"Batter: \(batterResult)")

    labelsBottom!.updateLabelNode(0, text:"Event: Hit", ham:.Center)
    //labelsBottom!.updateLabelNode(1, text:"Tap screen to continue", ham:.Center)

    delayGame()
    return EVENT
  }
  
  override func evtRunnerAdvance(dct:[String:AnyObject] = [:]) -> Int {
    print("evtRunnerAdvance() dct:\(dct)")
    let bases = dct["bases"] as! Int
    //dctRunnerAdvance = dct
    
    labels!.hideLabels()
    labels!.updateLabelNode(0, text:"\(half) of \(inning)", ham:.Center)
    var i = 1
    if let val = dct["3B"] { labels!.updateLabelNode(i++, text:"3B -> \(val)") }
    if let val = dct["2B"] { labels!.updateLabelNode(i++, text:"2B -> \(val)") }
    if let val = dct["1B"] { labels!.updateLabelNode(i++, text:"1B -> \(val)") }
    if let val = dct["Batter"] { labels!.updateLabelNode(i++, text:"Batter -> \(val)") }

    labelsBottom!.updateLabelNode(0, text:"Event: RunnerAdvance", ham:.Center)
    //labelsBottom!.updateLabelNode(1, text:"Tap screen to continue", ham:.Center)

    field!.runnersAdvance(dct)
    
    let timeSec:Int64 = Int64(bases*Int(RUNNER_ADVANCE_DURATION))
    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), timeSec * Int64(NSEC_PER_SEC))
    dispatch_after(time, dispatch_get_main_queue())
    {
        self.summary!.runnersAdvance(dct)
        self.scene!.runGame()
    }

    return EVENT
  }
  
  override func evtRun(dct:[String:AnyObject] = [:]) -> Int {
    print("evtRun() dct:\(dct)")
    let runs = dct["runs"] as! Int

    labels!.hideLabels()
    labels!.updateLabelNode(0, text:"\(half) of \(inning)", ham:.Center)
    labels!.updateLabelNode(1, text:"\(runs) runs scored")

    labelsBottom!.updateLabelNode(0, text:"Event: Run", ham:.Center)
    //labelsBottom!.updateLabelNode(1, text:"Tap screen to continue", ham:.Center)

    delayGame()

    return EVENT
  }
  
  override func evtSideRetired(dct:[String:AnyObject] = [:]) -> Int {
    print("evtSideRetired() dct:\(dct)")
    let srd_runs = dct["runs"] as! Int
    let srd_hits = dct["hits"] as! Int
    let srd_errors = dct["errors"] as! Int
    let srd_lob = dct["lob"] as! Int

    labels!.hideLabels()
    labels!.updateLabelNode(0, text:"\(half) of \(inning)", ham:.Center)
    labels!.updateLabelNode(1, text:"Side Retired")
    labels!.updateLabelNode(2, text:"\(srd_runs) runs \(srd_hits) hits \(srd_errors) errors \(srd_lob) LOB")

    outs = 0
    
    labelsBottom!.updateLabelNode(0, text:"Event: SideRetired", ham:.Center)
    //labelsBottom!.updateLabelNode(1, text:"Tap screen to continue", ham:.Center)

    field!.sideRetired()

    delayGame()

    return EVENT
  }
}
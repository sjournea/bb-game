//
//  Game.swift
//  BBGame
//
//  Created by Steven Journeay on 9/29/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation
import GameplayKit

enum GameEvent: Int, CustomStringConvertible {
    
  case GameIdle,
  GameStart,  // visitor, home, start time
  GameEnd,
  SideRetired,
  AtBat,
  Out,
  Hit,
  Run,
  Error,
  Selection,
  InningStart,
  RunnerAdvance,
  GameInit,
  GameFinal,
  Walkoff
  
  var description : String {
    get {
      switch(self) {
        case GameIdle: return "GameIdle"
        case GameStart: return "GameStart"
        case GameEnd: return "GameEnd"
        case SideRetired: return "SideRetired"
        case AtBat: return "AtBat"
        case Out: return "Out"
        case Hit: return "Hit"
        case Run: return "Run"
        case Error: return "Error"
        case Selection: return "Selection"
        case InningStart: return "InningStart"
        case RunnerAdvance: return "RunnerAdvance"
        case GameInit: return "GameInit"
        case GameFinal: return "GameFinal"
        case Walkoff: return "Walkoff"
      }
    }
  }
}

let EVENT_CONTINUE:Int = 0
let EVENT_RETURN:Int = 1

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

class Game {
  let version = BINARY_VERSION.VERSION
  var visitor:Team
  var home:Team
  var lstSelections:[Selection] = []
  var _outs:Int = 0
  var _inning:Int = 1
  var _1B:Bool = false
  var _2B:Bool = false
  var _3B:Bool = false
  var _final:Bool = false
  var _last_inning = 7
  var _up:Team
  var _field:Team
  var _pctError:Int = 0
  var _srd:SideRetiredData
  var sel:Selection
  var lastSelection:Selection
  var runs:Int = 0
  var gameEvent:GameEvent = GameEvent.GameIdle
  var createSelectionsFunc:CreateSelectionFuncType = CreateSelection

  
  init() {
    self.visitor = Team()
    self.home = Team()
    // self.lstSelections = generate_selections()
    self._srd = SideRetiredData()
    self._up = self.visitor
    self._field = self.home
    self.sel = Selection(sel:BB.OUT, index:0)
    self.lastSelection = self.sel
  }
    
  func encode(stPack:StructPack) {
    // version UInt8
    stPack.pack("B", values:[version.rawValue])
    // object id  12s     (database)
    // visitor       Team
    // home          Team
    // lstSelections [Selections]
    // srd           SideRetiredData
    visitor.encode(stPack)
    home.encode(stPack)
    stPack.pack(">H", values:[lstSelections.count])
    for sel in lstSelections {
      sel.encode(stPack)
    }
    _srd.encode(stPack)
    // _up          bool (false visitor, true home)
    // _outs        unsigned char
    // _inning      unsigned char
    // _1B          bool
    // _2B          bool
    // _3B          bool
    // _final       bool
    // _pctError    unsigned char
    // _last_inning unsigned char
    // gameState    unsigned char
    let up:Bool = home == _up
    stPack.pack(">?BB????BBB", values:[up, _outs, _inning, _1B, _2B, _3B, _final, _pctError, _last_inning, gameEvent.rawValue])
  }
  
  func decode(stUnpack:StructUnpack) {
    // version UInt8
    var values:[AnyObject] = stUnpack.unpack("B")
    let decode_version = values[0] as! UInt
    
    if decode_version == 1 {
      // object id  12s     (database)
      // visitor       Team
      // home          Team
      // lstSelections [Selections]
      // srd           SideRetiredData
      visitor.decode(stUnpack)
      home.decode(stUnpack)
      values = stUnpack.unpack(">H")
      let cnt = values[0] as! Int
      lstSelections.removeAll()
      for _ in 0 ..< cnt {
        let sel = Selection(stUnpack:stUnpack)
        lstSelections.append(sel)
      }
      _srd.decode(stUnpack)
      // _up          bool (false visitor, true home)
      // _outs        unsigned char
      // _inning      unsigned char
      // _1B          bool
      // _2B          bool
      // _3B          bool
      // _final       bool
      // _pctError    unsigned char
      // _last_inning unsigned char
      // gameState    unsigned char
      values = stUnpack.unpack(">?BB????BBB")
      let up = values[0] as! Bool
      _outs = values[1] as! Int
      _inning = values[2] as! Int
      _1B = values[3] as! Bool
      _2B = values[4] as! Bool
      _3B = values[5] as! Bool
      _final = values[6] as! Bool
      _pctError = values[7] as! Int
      _last_inning = values[8] as! Int
      let event = values[9] as! Int
      _up = up ? home : visitor
      _field = up ? visitor : home
      gameEvent = GameEvent(rawValue: event)!
    }
  }
  
  private func event_publish(evt:GameEvent, dct:[String:AnyObject]=[:]) -> Int {
        
    self.gameEvent = evt
    switch evt {
      case .GameIdle: break
      case .GameInit:  break
      case .GameStart: return evtGameStart(dct)
      case .GameEnd:   return evtGameEnd(dct)
      case .SideRetired: return evtSideRetired(dct)
      case .AtBat: return evtAtBat(dct)
      case .Out: return evtOut(dct)
      case .Hit: return evtHit(dct)
      case .Run: return evtRun(dct)
      case .Error: return evtError(dct)
      case .Selection: return evtSelection(dct)
      case .InningStart: return evtInningStart(dct)
      case .RunnerAdvance: return evtRunnerAdvance(dct)
      case .GameFinal: return evtGameFinal(dct)
      case .Walkoff: return evtWalkoff(dct)
    }
    return EVENT_RETURN
  }
    
  func setup_game(visitor:Team, home:Team, pctError:Int = 0) {
    // assert(pctError >= 0.0 && pctError < 1.0, "pctError is illegal")
    self.visitor = visitor
    self.home = home
    _pctError = pctError
    
    self.lstSelections = generate_selections(createFunc: createSelectionsFunc)
  }
  
  func setup_selection(createFunc:CreateSelectionFuncType) {
    createSelectionsFunc = createFunc
  }
  
  func start_game() {
    gameEvent = GameEvent.GameInit
    run_game()
  }
    
  func run_game() {
    // Run the Game FSM
    var status:Int = 0
    repeat {
      switch gameEvent {
        case .GameIdle:  status = self.stGameIdle()
        case .GameInit:  status = self.stGameInit()
        case .GameStart: status = self.stGameStart()
        case .GameEnd:   status = self.stGameEnd()
        case .SideRetired: status = self.stSideRetired()
        case .AtBat: status = self.stAtBat()
        case .Out: status = self.stOut()
        case .Hit: status = self.stHit()
        case .Run: status = self.stRun()
        case .Error: status = self.stError()
        case .Selection: status = self.stSelection()
        case .InningStart: status = self.stInningStart()
        case .RunnerAdvance: status = self.stRunnerAdvance()
        case .GameFinal: status = self.stGameFinal()
        case .Walkoff: status = self.stWalkoff()
      }
    } while status == EVENT_CONTINUE
  }
    
  private func stGameIdle() -> Int {
    // GAME_IDLE => GAME_IDLE
    return EVENT_RETURN
  }
    
  private func stGameEnd() -> Int {
    // GAME_END => GAME_IDLE
    // Stop the FSM
    gameEvent = GameEvent.GameIdle
    return EVENT_RETURN
  }
    
  private func stGameFinal() -> Int {
    // GAME_FINAL => GAME_END
    return event_publish( GameEvent.GameEnd)
  }
  
  private func stWalkoff() -> Int {
    // Walkoff => GAME_FINAL
    return event_publish( GameEvent.GameFinal)
  }
  
  private func stGameInit() -> Int {
    // GAME_INIT => GAME_START
    self.visitor.start_game()
    self.home.start_game()
    self._up = self.visitor
    self._field = self.home
    self._outs = 0
    self._inning = 1
    self._1B = false
    self._2B = false
    self._3B = false
    self._final = false
    self._last_inning = 7
    self._srd.clear()
        
    // Start the game
    return event_publish(GameEvent.GameStart)
  }
    
  private func stGameStart() -> Int {
    // GAME_START => INNING_START
    self._up.at_bat()
    return event_publish( GameEvent.InningStart, dct:["inning":1, "half":"top", "up":self._up])
  }
    
  private func stInningStart() -> Int {
    // INNING_START => AT_BAT
    return event_publish(GameEvent.AtBat, dct:["team":self._up])
  }
    
  private func stAtBat() -> Int {
    // AT_BAT => AT_BAT
    // in_play(idx) changes this state
    return EVENT_RETURN
  }
    
  private func stSelection() -> Int {
    // SELECTION => OUT|HIT|ERROR
    // Process selection
    self.runs = 0
    if self.sel.sel!.isOut() {
      self._outs++
      return event_publish(GameEvent.Out, dct:["team":self._up, "outs":self._outs])
    } else if self.sel.sel!.isError() {
      self._srd.errors++
      self._field.errors++
      return event_publish(GameEvent.Error, dct:["team":self._field, "error":self.sel.sel!.description])
    } else { // if self.sel.sel.isHit() {
      self._up.hits++
      self._srd.hits++
      return event_publish(GameEvent.Hit, dct:["team":self._up, "hit":self.sel.sel!.description, "bases":self.sel.sel!.bases()])
    }
  }
    
  private func stOut() -> Int {
    /// OUT => AT_BAT | SIDE_RETURED
    if self._outs == 3 {
      // 3 outs -- update stats
      // update LOB
      if self._1B { self._srd.lob++ }
      if self._2B { self._srd.lob++ }
      if self._3B { self._srd.lob++ }
      self._up.lob += self._srd.lob
      // clear the bases
      self._1B = false
      self._2B = false
      self._3B = false
      self._outs = 0
      // side retired event
      return event_publish(GameEvent.SideRetired, dct:["runs":self._srd.runs, "hits":self._srd.hits, "errors":self._srd.errors, "lob":self._srd.lob])
    }
    return event_publish(GameEvent.AtBat,dct:["team":self._up])
  }
    
  private func stError() -> Int {
    // ERROR => RUNNER_ADVANCE
    var dctRunners:[String:AnyObject] = [:]
    dctRunners["bases"] = self.sel.sel!.bases()
    if self.sel.sel == BB.ERROR_1B {
      dctRunners["Batter"] = "1B"
      if (self._3B) {
        self.runs++
        self._3B = false
        dctRunners["3B"] = "Home"
      }
      if (self._2B) {
        self._3B = true
        self._2B = false
        dctRunners["2B"] = "3B"
      }
      if (self._1B) {
        self._2B = true
        dctRunners["1B"] = "2B"
      }
      self._1B = true
    } else if self.sel.sel == BB.ERROR_2B {
      dctRunners["Batter"] = "2B"
      if (self._3B) {
        self.runs++
        self._3B = false
        dctRunners["3B"] = "Home"
      }
      if (self._2B) {
        self.runs++
        self._2B = false
        dctRunners["2B"] = "Home"
      }
      if (self._1B) {
        self._3B = true
        dctRunners["1B"] = "3B"
        self._1B = false
      }
      self._2B = true
    }
    return event_publish(GameEvent.RunnerAdvance, dct:dctRunners)
  }
    
  private func stHit() -> Int {
    // HIT => RUNNER_ADVANCE
    var dctRunners:[String:AnyObject] = [:]
    dctRunners["bases"] = self.sel.sel!.bases()
    if self.sel.sel == BB.SINGLE {
      dctRunners["Batter"] = "1B"
      if (self._3B) {
        self.runs++
        self._3B = false
        dctRunners["3B"] = "Home"
      }
      if (self._2B) {
        self._3B = true
        self._2B = false
        dctRunners["2B"] = "3B"
      }
      if (self._1B) {
        self._2B = true
        dctRunners["1B"] = "2B"
      }
      self._1B = true
    } else if self.sel.sel == BB.DOUBLE {
      dctRunners["Batter"] = "2B"
      if (self._3B) {
        self.runs++
        self._3B = false
        dctRunners["3B"] = "Home"
      }
      if (self._2B) {
        self.runs++
        self._2B = false
        dctRunners["2B"] = "Home"
      }
      if (self._1B) {
        self._3B = true
        dctRunners["1B"] = "3B"
        self._1B = false
      }
      self._2B = true
    } else if self.sel.sel == BB.TRIPLE {
      dctRunners["Batter"] = "3B"
      if (self._3B) {
        self.runs++
        dctRunners["3B"] = "Home"
      }
      if (self._2B) {
        self.runs++
        self._2B = false
        dctRunners["2B"] = "Home"
      }
      if (self._1B) {
        self.runs++
        self._1B = false
        dctRunners["1B"] = "Home"
      }
      self._3B = true
    } else if self.sel.sel == BB.HOMERUN {
      dctRunners["Batter"] = "Home"
      self.runs++
      if (self._3B) {
        self.runs++
        self._3B = false
        dctRunners["3B"] = "Home"
      }
      if (self._2B) {
        self.runs++
        self._2B = false
        dctRunners["2B"] = "Home"
      }
      if (self._1B) {
        self.runs++
        self._1B = false
        dctRunners["1B"] = "Home"
      }
    }
    return event_publish(GameEvent.RunnerAdvance, dct:dctRunners)
  }
    
  private func stRunnerAdvance() -> Int {
    // RUNNER_ADVANCE => RUN | AT_BAT
    // update score
    if (self.runs > 0) {
      self._srd.runs += self.runs
      self._up.score(self.runs)
      return event_publish(GameEvent.Run, dct:["team":self._up, "runs":self.runs])
    }
    return event_publish(GameEvent.AtBat, dct:["team":self._up])
  }
    
  private func stRun() -> Int {
    // RUN => AT_BAT | WALKOFF
    // check for end of game if in extra innings
    if (self._inning >= self._last_inning && self._up == self.home && self.home.runs > self.visitor.runs) {
      self._final = true
      return event_publish(GameEvent.Walkoff)
    }
    return event_publish(GameEvent.AtBat, dct:["team":self._up])
  }
    
  private func stSideRetired() -> Int {
    // SIDE_RETIRED => GAME_FINAL | INNING_START
    self._srd.clear()
    //
    var half:String = ""
    if self._up == self.visitor {
      self._up = self.home
      self._field = self.visitor
      half = "bottom"
      // check for game over,last inning and home leading, last at bat not needed
      if self._inning == self._last_inning && self.home.runs > self.visitor.runs {
        self.home.at_bat(-1)
        return event_publish(GameEvent.GameFinal)
      }
    } else {
      self._up = self.visitor
      self._field = self.home
      half = "top"
      // check for game over
      if self._inning >= self._last_inning && self.home.runs != self.visitor.runs {
        self._final = true
        return event_publish(GameEvent.GameFinal)
      }
      self._inning++
    }
    // event inning start
    self._up.at_bat()
    return  event_publish(GameEvent.InningStart, dct:["inning":self._inning, "half": half, "up": self._up])
  }
    
  func isVisitorUp() -> Bool {
    return self._up == self.visitor
  }
  
  func isHomeUp() -> Bool {
    return self._up == self.home
  }
  
  func checkSelection(idx:Int) -> Bool {
    sel = self.lstSelections[idx]
    return sel.isUsed()
  }
    
  func in_play(idx:Int) -> Bool {
    self.sel = self.lstSelections[idx]
    if self.sel.isUsed() {
      return false
    }
    // check for an error on out if a percentage is set
    if self.sel.sel == BB.OUT && self._pctError > 0 {
      let randomErrors = GKRandomDistribution(lowestValue: 0, highestValue: 99)
      if randomErrors.nextInt() < _pctError {
        // 10 % chance error is a 2B error
        // self.sel.sel = randomErrors.nextInt() < 10 ? BB.ERROR_2B : BB.ERROR_1B
        self.sel.sel = BB.ERROR_1B
      }
    }
    // use this selection
    self.sel.Used(_up)
    // save selection index to up team
    self._up.addSelection(idx)
    self.lastSelection = self.sel
    let status = event_publish(GameEvent.Selection, dct:["sel":self.sel,"idx":idx])
    if status == EVENT_CONTINUE {
      self.run_game()
    }
    return true
  }
    
  func is_final() -> Bool {
    return self._final
  }
    
  func base_status() -> String {
    var s = "Bases empty"
    var lst:[String] = []
    if (self._1B) { lst.append("1B") }
    if (self._2B) { lst.append("2B") }
    if (self._3B) { lst.append("3B") }
    if (!lst.isEmpty) {
      s = lst.joinWithSeparator(",")
    }
    return s
  }
    
  func status() -> String {
    var s = ""
    let score = "\(self.visitor.name) \(self.visitor.runs) \(self.home.name) \(self.home.runs)"
    if (self.is_final()) {
      s = "Final Score: " + score
    } else {
      var inning = (self._up == self.visitor) ? "Top" : "Bottom"
      inning += " of \(self._inning)"
      s = "Score: \(score) Inning: \(inning) \(self._up.name) up - \(self._outs) outs - " + self.base_status()
    }
    return s
  }
    
  func avail() -> [Int] {
    var lst:[Int] = []
    for (index, sel) in self.lstSelections.enumerate() {
      if (sel.isUsed()) {
        continue
      }
      lst.append(index)
    }
    return lst
  }
    
  func avail_selections() -> [Selection] {
    var lst:[Selection] = []
    for sel in self.lstSelections {
      if (sel.isUsed()) {
        continue
      }
      lst.append(sel)
    }
    return lst
  }
    
  func box_score(show_stats:Bool=false) ->[String] {
    var lst:[String] = []
    let last_inning = self._inning > self._last_inning ? self._inning : self._last_inning
    let width:Int = last_inning*3
    // headers
    let space:Character = " "
    var sTeam:String = String(count: 15, repeatedValue: space)
    var sInn:String = ""
    for x in 1...last_inning {
      sInn += String(format: "%3d", x)
    }
    var sRHE:String = "  R   H   E "
    lst.append( sTeam + " " + sInn + " " + sRHE )
    // visitor box score
    sInn = ""
    for score in self.visitor.innings {
      sInn += String(format:"%3d", score)
    }
    sInn += String(count: width, repeatedValue: space)
    sInn = sInn.substringToIndex(sInn.startIndex.advancedBy(width))
    sRHE = String(format:"%3d %3d %3d", self.visitor.runs, self.visitor.hits, self.visitor.errors)
    sTeam = self.visitor.name + "               "
    sTeam = sTeam.substringToIndex(sTeam.startIndex.advancedBy(15))
    lst.append(sTeam + " " + sInn + " " + sRHE)
        
    // home box score
    sInn = ""
    for score in self.home.innings {
      if (score == -1) {
        sInn += "  x"
      } else {
        sInn += String(format:"%3d", score)
      }
    }
    sInn += String(count: width, repeatedValue: space)
    sInn = sInn.substringToIndex(sInn.startIndex.advancedBy(width))
    sRHE = String(format:"%3d %3d %3d", self.home.runs, self.home.hits, self.home.errors)
    sTeam = self.home.name + "               "
    sTeam = sTeam.substringToIndex(sTeam.startIndex.advancedBy(15))
    lst.append(sTeam + " " + sInn + " " + sRHE)
        
    if (show_stats) {
      lst.append("")
      lst.append("LOB: \(self.home.name) \(self.home.lob), \(self.visitor.name) \(self.visitor.lob)")
    }
    return lst
  }
    
  func box_score2() ->[String:String] {
    var dct:[String:String] = [:]
        
    // visitor box score
    var sInn = ""
    for score in self.visitor.innings {
      sInn += String(format:"%3d", score)
    }
    dct["VisitorScore"] = sInn
    dct["VisitorRHE"] = String(format:"%2d %2d %2d", self.visitor.runs, self.visitor.hits, self.visitor.errors)
        
    // home box score
    sInn = ""
    for score in self.home.innings {
      if (score == -1) {
        sInn += "  x"
      } else {
        sInn += String(format:"%3d", score)
      }
    }
    dct["HomeScore"] = sInn
    dct["HomeRHE"] = String(format:"%2d %2d %2d", self.home.runs, self.home.hits, self.home.errors)
        
    return dct
  }
    
  func evtGameStart(dct:[String:AnyObject] = [:]) -> Int { return EVENT_CONTINUE }
  func evtGameFinal(dct:[String:AnyObject] = [:]) -> Int { return EVENT_CONTINUE }
  func evtGameEnd(dct:[String:AnyObject] = [:]) -> Int { return EVENT_CONTINUE }
  func evtInningStart(dct:[String:AnyObject] = [:]) -> Int { return EVENT_CONTINUE }
  func evtAtBat(dct:[String:AnyObject] = [:])  -> Int { return EVENT_CONTINUE }
  func evtSelection(dct:[String:AnyObject] = [:])  -> Int { return EVENT_CONTINUE }
  func evtOut(dct:[String:AnyObject] = [:])  -> Int { return EVENT_CONTINUE }
  func evtError(dct:[String:AnyObject] = [:])  -> Int { return EVENT_CONTINUE }
  func evtHit(dct:[String:AnyObject] = [:])  -> Int { return EVENT_CONTINUE }
  func evtRunnerAdvance(dct:[String:AnyObject] = [:])  -> Int { return EVENT_CONTINUE }
  func evtRun(dct:[String:AnyObject] = [:])  -> Int { return EVENT_CONTINUE }
  func evtSideRetired(dct:[String:AnyObject] = [:])  -> Int { return EVENT_CONTINUE }
  func evtWalkoff(dct:[String:AnyObject] = [:])  -> Int { return EVENT_CONTINUE }
}

func ==(left:Game, right:Game) -> Bool {
  var equal = left.visitor   == right.visitor &&
              left.home   == right.home &&
              left._up == right._up &&
              left._outs == right._outs &&
              left._inning == right._inning &&
              left._1B == right._1B &&
              left._2B == right._2B &&
              left._3B == right._3B &&
              left._final == right._final &&
              left._pctError == right._pctError &&
              left._srd == right._srd &&
              left._last_inning == right._last_inning &&
              left.gameEvent == right.gameEvent &&
              left.lstSelections.count == right.lstSelections.count
  if equal {
    for n in 0..<left.lstSelections.count {
      if left.lstSelections[n] != right.lstSelections[n] {
        equal = false
        break
      }
    }
  }
  return equal
}

func !=(left:Game, right:Game) -> Bool {
  return !(left == right)
}

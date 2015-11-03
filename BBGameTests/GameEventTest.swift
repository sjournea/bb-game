//
//  GameEventTest.swift
//  BBGame
//
//  Created by Steven Journeay on 11/1/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import XCTest
@testable import BBGame

class GameEventTester: Game {
  var tester:XCTestCase
  var dctGameEvents:[GameEvent:Int] =
  [ .GameIdle: 0,
    .GameStart: 0,
    .GameEnd:0,
    .SideRetired:0,
    .AtBat:0,
    .Out:0,
    .Hit:0,
    .Run:0,
    .Error:0,
    .Selection:0,
    .InningStart:0,
    .RunnerAdvance:0,
    .GameInit:0,
    .GameFinal:0,
    .Walkoff:0,
  ]

  init(tester:XCTestCase) {
    self.tester = tester
    super.init()
  }
  
  func addEventCall(event:GameEvent) {
    // let s = event.description
    if let value = dctGameEvents[event] {
      let n = value + 1
      dctGameEvents[event] = n
    }
  }
  
  override func evtGameStart(dct:[String:AnyObject] = [:]) -> Int {
    XCTAssertEqual(dct.count, 0)
    addEventCall(.GameStart)
    return EVENT_CONTINUE
  }
  
  override func evtGameFinal(dct:[String:AnyObject] = [:]) -> Int {
    XCTAssertEqual(dct.count, 0)
    addEventCall(.GameFinal)
    return EVENT_CONTINUE
  }
  
  override func evtGameEnd(dct:[String:AnyObject] = [:]) -> Int {
    XCTAssertEqual(dct.count, 0)
    addEventCall(.GameEnd)
    return EVENT_CONTINUE
  }
  
  override func evtInningStart(dct:[String:AnyObject] = [:]) -> Int {
    XCTAssertEqual(dct.count, 3)
    XCTAssertNotNil(dct["up"])
    XCTAssertNotNil(dct["inning"])
    XCTAssertNotNil(dct["half"])
    addEventCall(.InningStart)
    return EVENT_CONTINUE
  }
  
  override func evtAtBat(dct:[String:AnyObject] = [:])  -> Int {
    XCTAssertEqual(dct.count, 1)
    XCTAssertNotNil(dct["team"])
    addEventCall(.AtBat)
    return EVENT_CONTINUE
  }
  
  override func evtSelection(dct:[String:AnyObject] = [:])  -> Int {
    XCTAssertEqual(dct.count, 2)
    XCTAssertNotNil(dct["sel"])
    XCTAssertNotNil(dct["idx"])
    addEventCall(.Selection)
    return EVENT_CONTINUE
  }
  
  override func evtOut(dct:[String:AnyObject] = [:])  -> Int {
    XCTAssertEqual(dct.count, 2)
    XCTAssertNotNil(dct["team"])
    XCTAssertNotNil(dct["outs"])
    addEventCall(.Out)
    return EVENT_CONTINUE
  }
  
  override func evtError(dct:[String:AnyObject] = [:])  -> Int {
    XCTAssertEqual(dct.count, 2)
    XCTAssertNotNil(dct["team"])
    XCTAssertNotNil(dct["error"])
    addEventCall(.Error)
    return EVENT_CONTINUE
  }
  
  override func evtHit(dct:[String:AnyObject] = [:])  -> Int {
    XCTAssertEqual(dct.count, 3)
    XCTAssertNotNil(dct["team"])
    XCTAssertNotNil(dct["hit"])
    XCTAssertNotNil(dct["bases"])
    addEventCall(.Hit)
    return EVENT_CONTINUE
  }
  
  override func evtRunnerAdvance(dct:[String:AnyObject] = [:])  -> Int {
    XCTAssertGreaterThanOrEqual(dct.count, 1)
    XCTAssertLessThanOrEqual(dct.count, 5)
    XCTAssertNotNil(dct["Batter"])
    XCTAssertNotNil(dct["bases"])
    addEventCall(.RunnerAdvance)
    return EVENT_CONTINUE
  }
  
  override func evtRun(dct:[String:AnyObject] = [:])  -> Int {
    XCTAssertEqual(dct.count, 2)
    XCTAssertNotNil(dct["team"])
    XCTAssertNotNil(dct["runs"])
    addEventCall(.Run)
    return EVENT_CONTINUE
  }
  
  override func evtSideRetired(dct:[String:AnyObject] = [:])  -> Int {
    XCTAssertEqual(dct.count, 4)
    XCTAssertNotNil(dct["runs"])
    XCTAssertNotNil(dct["hits"])
    XCTAssertNotNil(dct["errors"])
    XCTAssertNotNil(dct["lob"])
    addEventCall(.SideRetired)
    return EVENT_CONTINUE
  }
  
  override func evtWalkoff(dct:[String:AnyObject] = [:])  -> Int {
    XCTAssertEqual(dct.count, 0)
    addEventCall(.Walkoff)
    return EVENT_CONTINUE
  }
}

class GameEventTest: XCTestCase {
  var home:Team?
  var visitor:Team?
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    home = Team(name:"Home", home: true, robot:false, tla:"HOM")
    visitor = Team(name: "Visitor", home: false, robot: false, tla: "VIS")
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
    
  func findSelection(game:Game, what:BB) -> Int? {
    // return index of specific selection, nil if none available
    let lst = game.avail_selections()
    for sel in lst {
      if sel.sel! == what {
        return sel.index
      }
    }
    return nil
  }
  
  func encodeDecodeVerify(game:Game) {
    // encode and decode and verify match
    let stPack = StructPack()
    game.encode(stPack)
    
    let nsdata:NSData = stPack.getData()
    
    let stUnpack = StructUnpack(nsdata:nsdata)
    let game2 = Game()
    game2.decode(stUnpack)
    XCTAssert(game == game2)
  }

  func testGameEvents() {
    let game = GameEventTester(tester:self)
    game.setup_game(visitor!, home:home!)
    game.start_game()
    
    while !game.is_final() {
      // random selection
      let idx = game.avail()[0]
      game.in_play(idx)
    }
    // now check event counts
    XCTAssertEqual(game.dctGameEvents[.GameStart], 1)
    XCTAssertGreaterThanOrEqual(game.dctGameEvents[.Selection]!, 39)    // at least 6 1/2 innings, min case all outs
    XCTAssertGreaterThanOrEqual(game.dctGameEvents[.SideRetired]!, 13)  // at least 6 1/2 innings
    XCTAssertGreaterThanOrEqual(game.dctGameEvents[.AtBat]!, 39)        // at least 6 1/2 innings, min case all outs
    XCTAssertGreaterThanOrEqual(game.dctGameEvents[.Out]!, 39)          // at least 6 1/2 innings, min case all outs
    XCTAssertGreaterThanOrEqual(game.dctGameEvents[.Run]!, 1)           // at least 1 to win game
    XCTAssertGreaterThanOrEqual(game.dctGameEvents[.Error]!, 0)         // pctError defaults to 0
    XCTAssertGreaterThanOrEqual(game.dctGameEvents[.InningStart]!, 13)  // at least 6 1/2 innings
    XCTAssertGreaterThanOrEqual(game.dctGameEvents[.RunnerAdvance]!, 1)           // at least 1 to win game
    XCTAssertEqual(game.dctGameEvents[.GameEnd], 1)
    XCTAssertEqual(game.dctGameEvents[.GameFinal], 1)
    XCTAssertLessThanOrEqual(game.dctGameEvents[.Walkoff]!, 1)          // 1 or 0
    
    
  }

/*
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measureBlock {
      // Put the code you want to measure the time of here.
    }
  }
*/
}

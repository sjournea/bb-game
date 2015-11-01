//
//  GameTest.swift
//  BBGame
//
//  Created by Steven Journeay on 10/31/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import XCTest
@testable import BBGame

class GameTest: XCTestCase {
  
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

  func testCreate() {
    let game = Game()
    game.setup_game(visitor!, home:home!)
    
    XCTAssert(game.visitor == visitor!)
    XCTAssert(game.home == home!)
    XCTAssertEqual(game.lstSelections.count, 100)
  }

  func testGameStart() {
    let game = Game()
    game.setup_game(visitor!, home:home!)
    game.start_game()
    
    XCTAssert(game._up == visitor!)
    XCTAssertEqual(game._outs, 0)
    XCTAssertEqual(game._inning, 1)
    XCTAssertEqual(game._1B, false)
    XCTAssertEqual(game._2B, false)
    XCTAssertEqual(game._3B, false)
    XCTAssertEqual(game._final, false)
    XCTAssertEqual(game._last_inning, 7)
    XCTAssertEqual(game.visitor.innings, [0] )
    XCTAssertEqual(game.home.innings, [])
  }

  func testGamePlayOuts() {
    let game = Game()
    game.setup_game(visitor!, home:home!)
    game.start_game()
    
    XCTAssertEqual(game._outs, 0)
    
    var idx = findSelection(game, what: BB.OUT)
    game.in_play(idx!)
    XCTAssertEqual(game._outs, 1)

    idx = findSelection(game, what: BB.OUT)
    game.in_play(idx!)
    XCTAssertEqual(game._outs, 2)
    
    idx = findSelection(game, what: BB.OUT)
    game.in_play(idx!)
    XCTAssertEqual(game._outs, 0)
    XCTAssert(game._up == home!)
  }

  func testGamePlayError() {
    let game = Game()
    // Errors set at 100%, All outs will be errors
    game.setup_game(visitor!, home:home!, pctError:100)
    game.start_game()
    
    XCTAssertEqual(game._outs, 0)
    XCTAssertEqual(game.home.errors, 0)
    XCTAssertEqual(game._pctError, 100)
    
    var idx = findSelection(game, what: BB.OUT)
    game.in_play(idx!)
    XCTAssertEqual(game._outs, 0)
    XCTAssertEqual(game.home.errors, 1)
    XCTAssertEqual(game._1B, true)
    XCTAssertEqual(game._2B, false)
    XCTAssertEqual(game._3B, false)
    
    idx = findSelection(game, what: BB.OUT)
    game.in_play(idx!)
    XCTAssertEqual(game._outs, 0)
    XCTAssertEqual(game.home.errors, 2)
    XCTAssertEqual(game._1B, true)
    XCTAssertEqual(game._2B, true)
    XCTAssertEqual(game._3B, false)
  }
  
  func testGameExtraInnings() {
    let game = Game()
    game.setup_game(visitor!, home:home!)
    game.start_game()
    
    for inning in 1...7  {
      XCTAssertEqual(game._inning, inning)
      XCTAssert(game._up == game.visitor)
      XCTAssert(game._field == game.home)
      // 3 up, 3 down visitors
      for _ in 1...3 {
        let idx = findSelection(game, what: BB.OUT)
        game.in_play(idx!)
      }
      XCTAssertEqual(game._inning, inning)
      XCTAssert(game._up == game.home)
      XCTAssert(game._field == game.visitor)
      // 3 up, 3 down home
      for _ in 1...3 {
        let idx = findSelection(game, what: BB.OUT)
        game.in_play(idx!)
      }
    }
    // extra innings now
    XCTAssertEqual(game._inning, 8)
    XCTAssertEqual(game.visitor.innings, [0,0,0,0,0,0,0,0])
    XCTAssertEqual(game.home.innings, [0,0,0,0,0,0,0])
  }

  func testGameWithHomeNotBattingInLastInning() {
    let game = Game()
    game.setup_game(visitor!, home:home!)
    game.start_game()
    
    for inning in 1...7  {
      // 3 up, 3 down visitors
      for _ in 1...3 {
        let idx = findSelection(game, what: BB.OUT)
        game.in_play(idx!)
      }
      // Home run for home team in 1st inning
      if inning == 1 {
        let idx = findSelection(game, what: BB.HOMERUN)
        game.in_play(idx!)
      }
      if inning == 7 {
        break
      }
      // 3 up, 3 down home
      for _ in 1...3 {
        let idx = findSelection(game, what: BB.OUT)
        game.in_play(idx!)
      }
    }
    // game should be over
    XCTAssertEqual(game._inning, 7)
    
    // XCTAssertEqual(game.is_final(), true)
    XCTAssertEqual(game.visitor.innings, [0,0,0,0,0,0,0])
    XCTAssertEqual(game.home.innings, [1,0,0,0,0,0,-1])
  }

  func testGameEncodeDecode() {
    let game = Game()
    game.setup_game(visitor!, home:home!)
    game.start_game()
    
    encodeDecodeVerify(game)
    
    while !game.is_final() {
      // get next avail
      let lst = game.avail()
      XCTAssertNotEqual(lst, [])
      game.in_play(lst[0])
      // verify
      encodeDecodeVerify(game)
    }
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

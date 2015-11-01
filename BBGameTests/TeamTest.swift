//
//  TeamTest.swift
//  BBGame
//
//  Created by Steven Journeay on 10/30/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import XCTest
@testable import BBGame

class TeamTest: XCTestCase {
    
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
    
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
    
  func testTeamCreate() {
    let name = "Bulldogs"
    let team = Team(name: name, home: true, robot: false, tla: "BUL")
    XCTAssert(team.name == name)
    XCTAssert(team.isHome())
    XCTAssert(team.isVisitor() == false)
    XCTAssert(team.isRobot() == false)
    XCTAssert(team.tla == "BUL")

    let name2 = "Cattledogs"
    let team2 = Team(name: name2, home: false, robot: true, tla: "CTL")
    XCTAssert(team2.name == name2)
    XCTAssert(team2.isHome() == false)
    XCTAssert(team2.isVisitor())
    XCTAssert(team2.isRobot())
    XCTAssert(team2.tla == "CTL")
}

  func testTeamStartGame() {
    let name = "Bulldogs"
    let team = Team(name: name, home: true, robot: false, tla: "BUL")
    team.start_game()
    XCTAssertEqual(team.runs, 0)
    XCTAssertEqual(team.hits, 0)
    XCTAssertEqual(team.errors, 0)
    XCTAssertEqual(team.lob, 0)
    XCTAssertEqual(team.innings, [])
  }

  func testEncodeDecode() {
    let name = "Bulldogs"
    let team = Team(name: name, home: true, robot: false, tla: "BUL")
    let name2 = "Cattledogs"
    let team2 = Team(name: name2, home: false, robot: true, tla: "CTL")
    
    let stPack = StructPack()
    team.encode(stPack)
    let nsdata:NSData = stPack.getData()
      
    let stUnpack = StructUnpack(nsdata:nsdata)
    team2.decode(stUnpack)
    XCTAssert(team2 == team)
  }
  
  func testEncodeDecodeMultiple() {
    let team1 = Team(name: "Team1", home: true, robot: false, tla: "TM1")
    let team2 = Team(name: "Team2", home: true, robot: false, tla: "TM2")
    let team3 = Team(name: "Team3", home: true, robot: false, tla: "TM3")
    
    let stPack = StructPack()
    team1.encode(stPack)
    team2.encode(stPack)
    team3.encode(stPack)
    let nsdata:NSData = stPack.getData()
    
    let stUnpack = StructUnpack(nsdata:nsdata)
    let team4 = Team(stUnpack:stUnpack)
    let team5 = Team(stUnpack:stUnpack)
    let team6 = Team(stUnpack:stUnpack)

    XCTAssert(team1 == team4)
    XCTAssert(team2 == team5)
    XCTAssert(team3 == team6)
  }
  
  func testTeamAtBat() {
    let team1 = Team(name:"Bulldogs", robot:false, home:true, tla:"BUL")
    
    team1.start_game()

    team1.at_bat()
    XCTAssertEqual(team1.innings, [0])
    team1.at_bat()
    XCTAssertEqual(team1.innings, [0,0])
    team1.at_bat()
    XCTAssertEqual(team1.innings, [0,0,0])
  }

  func testTeamScore() {
    let team1 = Team(name:"Bulldogs", robot:false, home:true, tla:"BUL")

    team1.start_game()
    team1.at_bat()
    team1.score()
    XCTAssertEqual(team1.runs, 1)
    XCTAssertEqual(team1.innings, [1])
    team1.score(2)
    XCTAssertEqual(team1.runs, 3)
    XCTAssertEqual(team1.innings, [3])
    team1.at_bat()
    team1.score()
    XCTAssertEqual(team1.runs, 4)
    XCTAssertEqual(team1.innings, [3,1])
  }
  
  func testEqualNotEqual() {
    let team1 = Team(name:"Bulldogs", robot:false, home:true, tla:"BUL")
    let team2 = Team(name:"Cattledogs", robot:true, home:false, tla:"CTL")
    let team4 = Team(name:"Bulldogs", robot:false, home:true, tla:"BUL")
    
    XCTAssert(team1 == team4)
    XCTAssert(team1 != team2)

    team1.start_game()
    team1.at_bat()
    
    XCTAssert(team1 != team4)
    XCTAssert(team1 != team2)
    
    team4.start_game()
    team4.at_bat()

    XCTAssert(team1 == team4)
    XCTAssert(team1 != team2)
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

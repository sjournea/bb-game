//
//  BBField.swift
//  BBGame
//
//  Created by Steven Journeay on 10/4/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation
import SpriteKit

enum PlayerPosition {
  case
  batting,
  onFirstBase,
  onSecondBase,
  onThirdBase,
  pitcher,
  catcher,
  dugout,
  score

}

class BBField : SKSpriteNode {
  let BG_COLOR = UIColor.whiteColor()
  let BASE_EMPTY_COLOR = UIColor.whiteColor()
  let BASE_OCCUPY_COLOR = UIColor.redColor()

  //  var diamond:SKShapeNode?
  var home:SKShapeNode?
  var firstBase:SKShapeNode?
  var secondBase:SKShapeNode?
  var thirdBase:SKShapeNode?
  var stickMen:[BBStickMan] = []
  var positions:[String:CGPoint] = [:]
  var stickManLocations:[PlayerPosition:BBStickMan] = [:]
  var game:BBGame?
  
  init(size:CGSize) {
      
    super.init( texture:nil, color:BG_COLOR, size:size)
    
    positions["home"] = CGPointMake(size.width/2.0, 40.0)
    positions["firstBase"] = CGPointMake(size.width-40.0, size.height / 2.0)
    positions["secondBase"] = CGPointMake(size.width/2.0, size.height - 40.0)
    positions["thirdBase"] = CGPointMake(40.0, size.height / 2.0)

    home = SKShapeNode(circleOfRadius: 30.0)
    home!.fillColor = UIColor.redColor()
    home!.position = positions["home"]!
    addChild(home!)

    firstBase = SKShapeNode(circleOfRadius: 30.0)
    firstBase!.fillColor = UIColor.redColor()
    firstBase!.position = positions["firstBase"]!
    addChild(firstBase!)

    secondBase = SKShapeNode(circleOfRadius: 30.0)
    secondBase!.fillColor = UIColor.redColor()
    secondBase!.position = positions["secondBase"]!
    addChild(secondBase!)

    thirdBase = SKShapeNode(circleOfRadius: 30.0)
    thirdBase!.fillColor = UIColor.redColor()
    thirdBase!.position = positions["thirdBase"]!
    addChild(thirdBase!)
    
    createStickMan()
    
  }
  private func createStickMan() {
    for var i = 0; i < 5; i++ {
      
      let stickMan = BBStickMan()
      stickMan.hidden = true
      addChild(stickMan)
      
      stickMen.append(stickMan)
    }
  }
  
  func batterUp() {
    // We need to move a stick man to the plate to bat
    for stick in stickMen {
      if stick.hidden {
        stick.hidden = false
        assert(stickManLocations[PlayerPosition.batting] == nil, "batterUp() fail -- stickman already batting")
        stickManLocations[PlayerPosition.batting] = stick
        stick.position = positions["home"]!
        return
      }
    }
    assert(true, "batterUp() -- No available stickman")
  }
  
  func batterOut() {
    // Batter is out, remove
    if let stick = stickManLocations.removeValueForKey(.batting) {
      stick.hidden = true
    }
  }
  
  func sideRetired() {
    // clear the bases
    let bases:[PlayerPosition] = [.onFirstBase, .onSecondBase, .onThirdBase]
    for base in bases {
      if let stick = stickManLocations.removeValueForKey(base) {
        stick.hidden = true
      }
    }
  }
  
  private func getPositionFromRunnerAdvance(pos:String) -> PlayerPosition {
    if pos == "Batter" { return .batting }
    if pos == "1B" { return .onFirstBase }
    if pos == "2B" { return .onSecondBase }
    if pos == "3B" { return .onThirdBase }
    if pos == "Home" { return .score }
    return .dugout
  }
  
  private func getStringFromRunnerAdvance(pos:String) -> String {
    if pos == "1B" { return "firstBase" }
    if pos == "2B" { return "secondBase" }
    if pos == "3B" { return "thirdBase" }
    return ""
  }
  
  func runnersAdvance(dct:[String:AnyObject]) {
    // We need to advance the runners

    for (start, end) in dct {
      let stop = end as! String

      let startPosition = getPositionFromRunnerAdvance(start)
      let stopPosition = getPositionFromRunnerAdvance(stop)

      let stick = stickManLocations[startPosition]
      assert(stick != nil, "runnerAdvance() -- \(startPosition) has no stickman")
      if stopPosition == .score {
        stick!.hidden = true
      } else {
        stickManLocations[stopPosition] = stick
        stick!.position = positions[getStringFromRunnerAdvance(stop)]!
      }
      stickManLocations.removeValueForKey(startPosition)
    }
  }
  
  func setGame(game:BBGame) {
    self.game = game
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder) has not been implemented")
  }
}



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
  let BG_COLOR = UIColor.greenColor()
  
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
    home!.fillColor = BASE_COLOR
    home!.position = positions["home"]!
    addChild(home!)

    firstBase = SKShapeNode(circleOfRadius: 30.0)
    firstBase!.fillColor = BASE_COLOR
    firstBase!.position = positions["firstBase"]!
    addChild(firstBase!)

    secondBase = SKShapeNode(circleOfRadius: 30.0)
    secondBase!.fillColor = BASE_COLOR
    secondBase!.position = positions["secondBase"]!
    addChild(secondBase!)

    thirdBase = SKShapeNode(circleOfRadius: 30.0)
    thirdBase!.fillColor = BASE_COLOR
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
  
  private func moveRunnerSequence(start:PlayerPosition, stop:PlayerPosition) -> [SKAction] {
    var actions:[SKAction] = []
    if start == .batting {
      actions.append(SKAction.moveTo(positions["firstBase"]!, duration: RUNNER_ADVANCE_DURATION))
      if stop == .onFirstBase { return actions }
      actions.append(SKAction.moveTo(positions["secondBase"]!, duration: RUNNER_ADVANCE_DURATION))
      if stop == .onSecondBase { return actions }
      actions.append(SKAction.moveTo(positions["thirdBase"]!, duration: RUNNER_ADVANCE_DURATION))
      if stop == .onThirdBase { return actions }
      actions.append(SKAction.moveTo(positions["home"]!, duration: RUNNER_ADVANCE_DURATION))
      actions.append(SKAction.hide())
    } else if start == .onFirstBase {
      actions.append(SKAction.moveTo(positions["secondBase"]!, duration: RUNNER_ADVANCE_DURATION))
      if stop == .onSecondBase { return actions }
      actions.append(SKAction.moveTo(positions["thirdBase"]!, duration: RUNNER_ADVANCE_DURATION))
      if stop == .onThirdBase { return actions }
      actions.append(SKAction.moveTo(positions["home"]!, duration: RUNNER_ADVANCE_DURATION))
      actions.append(SKAction.hide())
    } else if start == .onSecondBase {
      actions.append(SKAction.moveTo(positions["thirdBase"]!, duration: RUNNER_ADVANCE_DURATION))
      if stop == .onThirdBase { return actions }
      actions.append(SKAction.moveTo(positions["home"]!, duration: RUNNER_ADVANCE_DURATION))
      actions.append(SKAction.hide())
    } else if start == .onThirdBase {
      actions.append(SKAction.moveTo(positions["home"]!, duration: RUNNER_ADVANCE_DURATION))
      actions.append(SKAction.hide())
    }
    return actions
  }
  
  private func runnerAdvance(start:String, stop:String) {

    let startPosition = getPositionFromRunnerAdvance(start)
    let stopPosition = getPositionFromRunnerAdvance(stop)
    
    let stick = stickManLocations[startPosition]
    assert(stick != nil, "runnerAdvance() -- \(startPosition) has no stickman")
    
    let actions = moveRunnerSequence(startPosition, stop: stopPosition)
    let sequenceAction = SKAction.sequence(actions)
    stick!.runAction(sequenceAction)
    
    if stopPosition != .score {
      stickManLocations[stopPosition] = stick
    }
    stickManLocations.removeValueForKey(startPosition)
  }
  
  func runnersAdvance(dct:[String:AnyObject]) {
    // We need to advance the runners in the proper order
    let lst:[String] = ["3B", "2B", "1B", "Batter"]
    for start in lst {
      if let end = dct[start] {
        let stop = end as! String
        runnerAdvance(start, stop:stop)
      }
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder) has not been implemented")
  }
  
  func setGame(game:BBGame) {
    self.game = game
  }
}



//
//  GameScene.swift
//  BBGame
//
//  Created by Steven Journeay on 9/29/15.
//  Copyright (c) 2015 Taralaur Consultants, Inc. All rights reserved.
//

import SpriteKit

import SpriteKit

let BBfontSize:CGFloat = 19

class GameScene: SKScene {
  var visitor:Team?
  var home:Team?
  var game:BBGame?
  var scoreboard:ScoreBoard?
  let tapMessage1 = SKLabelNode(fontNamed: "Copperplate")
  let tapMessage2 = SKLabelNode(fontNamed: "Copperplate")
  let lblGameEvent = SKLabelNode(fontNamed: "Copperplate")
  var lstLabels:[SKLabelNode] = []
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
    
  override init(size: CGSize) {
    super.init(size: size)
        
    backgroundColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    visitor = Team(name:"Colonels")
    home = Team(name:"Aces")
    game = BBGame(scene:self)
    
    scoreboard = ScoreBoard(size: CGSize(width:size.width, height:60))
    scoreboard!.anchorPoint = CGPoint(x:0.0, y:0.0)
    scoreboard!.position = CGPointMake(0.0, size.height - 60.0)
    scoreboard!.hidden = true
    
    addScoreBoardNodes()
    addLabelNodes()
    
    updateAllText()
  }
  
  func addLabelNodes(num:Int=5) {
    
    var yOffset:CGFloat = 100.0
    let xOffset:CGFloat = 30.0
    
    for _ in 1...num {
      
      let node = SKLabelNode(fontNamed: "Copperplate")
      node.text = ""
      node.fontSize = BBfontSize
      node.fontColor = SKColor.blackColor()
      node.position = CGPointMake(xOffset, size.height-yOffset)
      node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
      node.hidden = true
      addChild(node)
    
      lstLabels.append(node)
      yOffset += 20.0
      
    }
  }
  
  func addScoreBoardNodes() {
        
    addChild(scoreboard!)
    
    lblGameEvent.text = ""
    lblGameEvent.fontSize = BBfontSize
    lblGameEvent.fontColor = SKColor.blackColor()
    lblGameEvent.position = CGPointMake(size.width / 2.0, 65)
    lblGameEvent.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(lblGameEvent)
    
    tapMessage1.text = "Tap screen"
    tapMessage1.fontSize = BBfontSize
    tapMessage1.fontColor = SKColor.blackColor()
    tapMessage1.position = CGPointMake(size.width / 2.0, 40)
    tapMessage1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(tapMessage1)
        
    tapMessage2.text = ""
    tapMessage2.fontSize = BBfontSize
    tapMessage2.fontColor = SKColor.blackColor()
    tapMessage2.position = CGPointMake(size.width / 2.0, 20)
    tapMessage2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(tapMessage2)
    
  }
    
  func updateAllText() {
        
    if game!.gameOver {
      scoreboard!.hideScore()
    } else {
      scoreboard!.updateScore()
    }
    
    // show next event
    tapMessage2.text = "\(game!.nextEvent)"
  }
    
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    print( "touchesBegan()")
        
    if game!.gameOver {
      game!.setup_game(visitor!, home:home!)
      scoreboard!.setGame(game!)
      scoreboard!.hidden = false
      game!.start_game()
    } else {

      game!.run_game()
      
      if game!.makeSelection {
        let idx = game!.avail()[0]
        game!.in_play(idx)
        game!.makeSelection = false
      }
    }
    
    updateAllText()
  }
    
  override func update(currentTime: NSTimeInterval) {
        
  }
}

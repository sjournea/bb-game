//
//  GameScene.swift
//  BBGame
//
//  Created by Steven Journeay on 9/29/15.
//  Copyright (c) 2015 Taralaur Consultants, Inc. All rights reserved.
//

import SpriteKit

let BBfontSize:CGFloat = 19

class GameScene: SKScene {
  var visitor:BBTeam?
  var home:BBTeam?
  var game:BBGame?
  var scoreboard:ScoreBoard?
  var labels:Labels?
  var labelsBottom:Labels?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
    
  override init(size: CGSize) {
    super.init(size: size)
        
    backgroundColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    scoreboard = ScoreBoard(size: CGSize(width:size.width, height:70))
    scoreboard!.anchorPoint = CGPoint(x:0.0, y:0.0)  // Lower right
    scoreboard!.position = CGPointMake(0.0, size.height - 70.0)
    scoreboard!.hidden = true
    addChild(scoreboard!)

    labels = Labels(size: CGSize(width:size.width, height:105), num:5)
    labels!.anchorPoint = CGPoint(x:0.0, y:0.0)   // Upper Left
    labels!.position = CGPointMake(0.0, size.height - 175.0)
    labels!.hidden = false
    addChild(labels!)

    labelsBottom = Labels(size: CGSize(width:size.width, height:42), num:2)
    labelsBottom!.anchorPoint = CGPoint(x:0.0, y:0.0)   // Upper Left
    labelsBottom!.position = CGPointMake(0.0, 0.0)
    labelsBottom!.hidden = false
    addChild(labelsBottom!)
    
    
    visitor = BBTeam(name:"Colonels", color:UIColor.greenColor())
    home = BBTeam(name:"Aces", color:UIColor.yellowColor())
    game = BBGame(scene:self)
    
    labelsBottom!.updateLabelNode(1, text:"Tap screen to start game", ham:.Center)
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    print( "touchesBegan()")
        
    if game!.gameOver {

      game!.setup_game(visitor!, home:home!)
      scoreboard!.setGame(game!)
      scoreboard!.hidden = false
      game!.start_game()
      scoreboard!.updateScore()
  
    } else {
      game!.run_game()
      if game!.makeSelection {
        let idx = game!.avail()[0]
        game!.in_play(idx)
        game!.makeSelection = false
      }
      scoreboard!.updateScore()
    }
  }
    
  override func update(currentTime: NSTimeInterval) {}
}

//
//  GameScene.swift
//  BBGame
//
//  Created by Steven Journeay on 9/29/15.
//  Copyright (c) 2015 Taralaur Consultants, Inc. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
  var visitor:BBTeam?
  var home:BBTeam?
  var game:BBGame?
  var scoreboard:ScoreBoard?
  var labels:Labels?
  var labelsBottom:Labels?
  var field : BBField?
  var selectionDisplay:SelectionDisplay?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
    
  override init(size: CGSize) {
    super.init(size: size)
        
    backgroundColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    field = BBField(size: CGSize(width:size.width, height:380.0))
    field!.anchorPoint = CGPoint(x:0.0, y:0.0)  // lower right
    field!.position = CGPointMake(0.0, 100.0)
    field!.hidden = true
    addChild(field!)
    
    scoreboard = ScoreBoard(size: CGSize(width:size.width, height:70))
    scoreboard!.anchorPoint = CGPoint(x:0.0, y:0.0)  // Lower right
    scoreboard!.position = CGPointMake(0.0, size.height - 70.0)
    scoreboard!.hidden = true
    addChild(scoreboard!)

    labels = Labels(size: CGSize(width:size.width, height:105), num:5)
    labels!.anchorPoint = CGPoint(x:0.0, y:0.0)   // Lower right
    labels!.position = CGPointMake(0.0, size.height - 175.0)
    labels!.hidden = false
    addChild(labels!)

    labelsBottom = Labels(size: CGSize(width:size.width, height:42), num:2)
    labelsBottom!.anchorPoint = CGPoint(x:0.0, y:0.0)   // Lower right
    labelsBottom!.position = CGPointMake(0.0, 0.0)
    labelsBottom!.hidden = false
    addChild(labelsBottom!)
    
    selectionDisplay = SelectionDisplay(size:CGSize(width:size.width, height:435))
    selectionDisplay!.position = CGPointMake(0.0, 42.0)
    selectionDisplay!.anchorPoint = CGPoint(x:0.0, y:0.0)  // Lower right
    selectionDisplay!.hidden = true
    addChild(selectionDisplay!)
    
    visitor = BBTeam(name:"Cubs", color:UIColor.whiteColor())
    home = BBTeam(name:"Mets", color:UIColor.blueColor())
    game = BBGame(scene:self)
    
    labelsBottom!.updateLabelNode(1, text:"Tap screen to start game", ham:.Center)
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    if game!.gameOver {

      scoreboard!.hidden = false
      field!.hidden = false
      game!.setup_game(visitor!, home:home!)
      scoreboard!.setGame(game!)
      game!.start_game()
      scoreboard!.updateScore()
      selectionDisplay!.setGame(game!)
  
    } else {
      if !game!.makeSelection {
        game!.run_game()
        scoreboard!.updateScore()
      }
    }
  }
    
  override func update(currentTime: NSTimeInterval) {}
}

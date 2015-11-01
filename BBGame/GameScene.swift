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
  var summaryDisplay:BBSummary?
  
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
    labels!.position = CGPointMake(0.0, size.height - 180.0)
    labels!.hidden = false
    addChild(labels!)
    
    summaryDisplay = BBSummary(size: CGSize(width:60, height:45))
    summaryDisplay!.anchorPoint = CGPoint(x:0.0, y:0.0)  // Lower right
    summaryDisplay!.position = CGPointMake(size.width - 60, size.height - 120.0)
    summaryDisplay!.hidden = true
    addChild(summaryDisplay!)

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
    
    home = BBTeam(name:"Mets", color:UIColor.whiteColor(), home:true, robot:false, tla:"NYM")
    visitor = BBTeam(name:"Royals", color:UIColor.blueColor(), home:false, robot:true, tla:"KC")
    game = BBGame()
    game?.setScene(self)
    
    startGame()
  }
  
  
  func startGame() {

    scoreboard!.hidden = false
    field!.hidden = false
    summaryDisplay!.hidden = false
    game!.setup_selection(CreateBBSelection)
    game!.setup_game(visitor!, home:home!, pctError: 5)
    scoreboard!.setGame(game!)
    game!.start_game()
    scoreboard!.updateScore()
    selectionDisplay!.setGame(game!)
    
  }
  
  func runGame() {
    game!.run_game()
    scoreboard!.updateScore()
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    if game!.gameOver == false && game!.makeSelection == false {
      runGame()
    }
  }
    
  func swipedRight(sender:UISwipeGestureRecognizer){
    print("swiped right")
  }
  
  func swipedLeft(sender:UISwipeGestureRecognizer){
    print("swiped left")
  }
  
  func swipedUp(sender:UISwipeGestureRecognizer){
    print("swiped up")
  }
  
  func swipedDown(sender:UISwipeGestureRecognizer){
    print("swiped down")
  }
  
  override func didMoveToView(view: SKView) {
    
    /* Setup your scene here */
    
    let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:"))
    swipeRight.direction = .Right
    view.addGestureRecognizer(swipeRight)
    
    
    let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
    swipeLeft.direction = .Left
    view.addGestureRecognizer(swipeLeft)
    
    
    let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedUp:"))
    swipeUp.direction = .Up
    view.addGestureRecognizer(swipeUp)
    
    
    let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedDown:"))
    swipeDown.direction = .Down
    view.addGestureRecognizer(swipeDown)
  }
  
  override func update(currentTime: NSTimeInterval) {}
}

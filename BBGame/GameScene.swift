//
//  GameScene.swift
//  BBGame
//
//  Created by Steven Journeay on 9/29/15.
//  Copyright (c) 2015 Taralaur Consultants, Inc. All rights reserved.
//

import SpriteKit

import SpriteKit

class GameScene: SKScene {
  let BBfontSize:CGFloat = 19
  var visitor:Team?
  var home:Team?
  var game:BBGame?
  let hdr = SKLabelNode(fontNamed: "Copperplate")
  let visitorName = SKLabelNode(fontNamed: "Copperplate")
  let homeName = SKLabelNode(fontNamed: "Copperplate")
  let visitorScore = SKLabelNode(fontNamed: "Copperplate")
  let homeScore = SKLabelNode(fontNamed: "Copperplate")
  let visitorRHE = SKLabelNode(fontNamed: "Copperplate")
  let homeRHE = SKLabelNode(fontNamed: "Copperplate")
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
        
    addScoreBoardNodes()
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
        
    hdr.text = "1  2  3  4  5  6  7   R  H  E"
    hdr.fontSize = BBfontSize
    hdr.fontColor = SKColor.blackColor()
    hdr.position = CGPointMake((size.width*5)/16, size.height-30.0)
    hdr.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    addChild(hdr)
        
    visitorName.text = "\(visitor!.name)"
    visitorName.fontSize = BBfontSize
    visitorName.fontColor = SKColor.blackColor()
    visitorName.position = CGPointMake(10, size.height-50.0)
    visitorName.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    addChild(visitorName)
        
    visitorScore.text = ""
    visitorScore.fontSize = BBfontSize
    visitorScore.fontColor = SKColor.blackColor()
    visitorScore.position = CGPointMake((size.width*5)/16, size.height-50.0)
    visitorScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    addChild(visitorScore)
        
    visitorRHE.text = "0  0  0"
    visitorRHE.fontSize = BBfontSize
    visitorRHE.fontColor = SKColor.blackColor()
    visitorRHE.position = CGPointMake(285, size.height-50.0)
    visitorRHE.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    addChild(visitorRHE)
        
    homeName.text = "\(home!.name)"
    homeName.fontSize = BBfontSize
    homeName.fontColor = SKColor.blackColor()
    homeName.position = CGPointMake(10, size.height-70.0)
    homeName.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    addChild(homeName)
        
    homeScore.text = ""
    homeScore.fontSize = BBfontSize
    homeScore.fontColor = SKColor.blackColor()
    homeScore.position = CGPointMake((size.width*5)/16, size.height-70.0)
    homeScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    addChild(homeScore)
        
    homeRHE.text = "0  0  0"
    homeRHE.fontSize = BBfontSize
    homeRHE.fontColor = SKColor.blackColor()
    homeRHE.position = CGPointMake(285, size.height-70.0)
    homeRHE.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    addChild(homeRHE)
        
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
    
    addLabelNodes()
        
    updateAllText()
  }
    
  func updateAllText() {
        
    visitorScore.hidden = true
    homeScore.hidden = true
    visitorRHE.hidden = true
    homeRHE.hidden = true
        
    if !game!.gameOver {
      // update box score
      var dct:[String:String] = game!.box_score2()
      visitorScore.text = dct["VisitorScore"]
      homeScore.text = dct["HomeScore"]
      visitorRHE.text = dct["VisitorRHE"]
      homeRHE.text = dct["HomeRHE"]
      visitorScore.hidden = false
      homeScore.hidden = false
      visitorRHE.hidden = false
      homeRHE.hidden = false
    }
    // show next event
    tapMessage2.text = "\(game!.nextEvent)"
  }
    
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    print( "touchesBegan()")
        
    if game!.gameOver {
      game!.setup_game(visitor!, home:home!)
      game!.start_game()
    } else {

      game!.run_game()
      
      if game!.makeSelection {
        let idx = game!.avail()[0]
        game!.in_play(idx)
        game!.makeSelection = false
      }
        
      if game!.sideRetired {
      }
    }
    
    updateAllText()
  }
    
  override func update(currentTime: NSTimeInterval) {
        
  }
}

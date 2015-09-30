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
  let status = SKLabelNode(fontNamed: "Copperplate")
  let hdr = SKLabelNode(fontNamed: "Copperplate")
  let visitorName = SKLabelNode(fontNamed: "Copperplate")
  let homeName = SKLabelNode(fontNamed: "Copperplate")
  let visitorScore = SKLabelNode(fontNamed: "Copperplate")
  let homeScore = SKLabelNode(fontNamed: "Copperplate")
  let visitorRHE = SKLabelNode(fontNamed: "Copperplate")
  let homeRHE = SKLabelNode(fontNamed: "Copperplate")
  let sideRetired = SKLabelNode(fontNamed: "Copperplate")
  let sideRetired2 = SKLabelNode(fontNamed: "Copperplate")
  let runsScored = SKLabelNode(fontNamed: "Copperplate")
  let tapMessage1 = SKLabelNode(fontNamed: "Copperplate")
  let tapMessage2 = SKLabelNode(fontNamed: "Copperplate")
  let batterResult = SKLabelNode(fontNamed: "Copperplate")
    
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
    
  override init(size: CGSize) {
    super.init(size: size)
        
    backgroundColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    visitor = Team(name:"Colonels")
    home = Team(name:"Aces")
    game = BBGame()
        
    addScoreBoardNodes()
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
        
    // status.text = "\(game!.half) of \(game!.inning) -- \(game!.outs) outs - \(game!.base_status())"
    status.text = ""
    status.fontSize = BBfontSize
    status.fontColor = SKColor.blackColor()
    status.position = CGPointMake(30, size.height-100.0)
    status.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    addChild(status)
        
    batterResult.text = ""
    batterResult.fontSize = BBfontSize
    batterResult.fontColor = SKColor.blackColor()
    batterResult.position = CGPointMake(30, size.height-140.0)
    batterResult.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    addChild(batterResult)
        
    runsScored.text = ""
    runsScored.fontSize = BBfontSize
    runsScored.fontColor = SKColor.blackColor()
    runsScored.position = CGPointMake(30, size.height-160.0)
    runsScored.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    addChild(runsScored)
        
    sideRetired.text = "Side Retired"
    sideRetired.fontSize = BBfontSize
    sideRetired.fontColor = SKColor.blackColor()
    sideRetired.position = CGPointMake(30, size.height-140.0)
    sideRetired.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    addChild(sideRetired)
        
    //sideRetired2.text = "\(game!.srd_runs) runs \(game!.srd_hits) hits \(game!.srd_errors) errors \(game!.srd_lob) LOB"
    sideRetired2.text = ""
    sideRetired2.fontSize = BBfontSize
    sideRetired2.fontColor = SKColor.blackColor()
    sideRetired2.position = CGPointMake(30, size.height-160.0)
    sideRetired2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    addChild(sideRetired2)
        
    tapMessage1.text = "Tap screen"
    tapMessage1.fontSize = BBfontSize
    tapMessage1.fontColor = SKColor.blackColor()
    tapMessage1.position = CGPointMake(80, 40)
    tapMessage1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    addChild(tapMessage1)
        
    tapMessage2.text = ""
    //tapMessage2.text = "\(game!.nextEvent)"
    tapMessage2.fontSize = BBfontSize
    tapMessage2.fontColor = SKColor.blackColor()
    tapMessage2.position = CGPointMake(30, 20)
    tapMessage2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    addChild(tapMessage2)
        
    updateAllText()
  }
    
  func updateAllText() {
        
    sideRetired.hidden = true
    sideRetired2.hidden = true
    runsScored.hidden = true
    batterResult.hidden = true
    status.hidden = true
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
            
      // update game status
      status.text = "\(game!.half) of \(game!.inning) -- \(game!.outs) outs - \(game!.base_status())"
      status.hidden = false
            
      // show side retired if needed
      if game!.sideRetired {
                
        sideRetired2.text = "\(game!.srd_runs) runs \(game!.srd_hits) hits \(game!.srd_errors) errors \(game!.srd_lob) LOB"
        sideRetired.hidden = false
        sideRetired2.hidden = false
                
      } else {
                
        // update game status
        if game!.batterResult != "" {
          batterResult.text = "Batter: \(game!.batterResult)"
          batterResult.hidden = false
        }
                
        // show runs scored if needed
        if game!.runs > 0 {
          runsScored.text = "\(game!.runs) Run(s) scored"
          runsScored.hidden = false
        }
      }
    }
        
    // show next event
    tapMessage2.text = "\(game!.nextEvent)"
  }
    
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    print( "touchesBegan()")
        
    if game!.makeSelection {
      let idx = game!.avail()[0]
      game!.in_play(idx)
    }
        
    if game!.sideRetired {
    }
        
    if game!.gameOver {
      game!.setup_game(visitor!, home:home!)
      game!.start_game()
    }
        
    updateAllText()
  }
    
  override func update(currentTime: NSTimeInterval) {
        
  }
}

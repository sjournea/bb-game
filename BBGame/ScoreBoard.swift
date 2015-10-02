//
//  ScoreBoard.swift
//  BBGame
//
//  Created by Steven Journeay on 9/30/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation
import SpriteKit

let RUNS_OFFSET:CGFloat = 310
let HITS_OFFSET:CGFloat = RUNS_OFFSET + 27
let ERRORS_OFFSET:CGFloat = HITS_OFFSET + 27
let INNINGS_OFFSET:CGFloat = 120
let INNINGS_INCREMENT:CGFloat = 25

class ScoreBoard : SKSpriteNode {
  
  var game:BBGame?
  let lblVisitorName = SKLabelNode(fontNamed: "Copperplate")
  let lblHomeName = SKLabelNode(fontNamed: "Copperplate")
  var lblVisitorScore:[SKLabelNode] = []
  var lblHomeScore:[SKLabelNode] = []
  let lblHdrRuns = SKLabelNode(fontNamed: "Copperplate")
  let lblHdrHits = SKLabelNode(fontNamed: "Copperplate")
  let lblHdrErrors = SKLabelNode(fontNamed: "Copperplate")
  let lblVisitorRuns = SKLabelNode(fontNamed: "Copperplate")
  let lblVisitorHits = SKLabelNode(fontNamed: "Copperplate")
  let lblVisitorErrors = SKLabelNode(fontNamed: "Copperplate")
  let lblHomeRuns = SKLabelNode(fontNamed: "Copperplate")
  let lblHomeHits = SKLabelNode(fontNamed: "Copperplate")
  let lblHomeErrors = SKLabelNode(fontNamed: "Copperplate")

  init(size:CGSize) {
    super.init( texture:nil, color:UIColor.whiteColor(), size:size)
    
    var xOffset:CGFloat = INNINGS_OFFSET
    for i in 1...7 {
      let node = SKLabelNode(fontNamed: "Copperplate")
      node.text = "\(i)"
      node.fontSize = BBfontSize
      node.fontColor = SKColor.blackColor()
      node.position = CGPointMake(xOffset, 40.0)
      node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
      addChild(node)

      let vis = SKLabelNode(fontNamed: "Copperplate")
      vis.text = ""
      vis.fontSize = BBfontSize
      vis.fontColor = SKColor.blackColor()
      vis.position = CGPointMake(xOffset, 20.0)
      vis.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
      addChild(vis)
      lblVisitorScore.append(vis)

      let hom = SKLabelNode(fontNamed: "Copperplate")
      hom.text = ""
      hom.fontSize = BBfontSize
      hom.fontColor = SKColor.blackColor()
      hom.position = CGPointMake(xOffset, 0.0)
      hom.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
      addChild(hom)
      lblHomeScore.append(hom)

      xOffset += INNINGS_INCREMENT
    }

    lblVisitorName.text = ""
    lblVisitorName.fontSize = BBfontSize
    lblVisitorName.fontColor = SKColor.blackColor()
    lblVisitorName.position = CGPointMake(10, 20.0)
    lblVisitorName.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    addChild(lblVisitorName)
    
    lblHdrRuns.text = "R"
    lblHdrRuns.fontSize = BBfontSize
    lblHdrRuns.fontColor = SKColor.blackColor()
    lblHdrRuns.position = CGPointMake(RUNS_OFFSET, 40.0)
    lblHdrRuns.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(lblHdrRuns)
    
    lblHdrHits.text = "H"
    lblHdrHits.fontSize = BBfontSize
    lblHdrHits.fontColor = SKColor.blackColor()
    lblHdrHits.position = CGPointMake(HITS_OFFSET, 40.0)
    lblHdrHits.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(lblHdrHits)
    
    lblHdrErrors.text = "E"
    lblHdrErrors.fontSize = BBfontSize
    lblHdrErrors.fontColor = SKColor.blackColor()
    lblHdrErrors.position = CGPointMake(ERRORS_OFFSET, 40.0)
    lblHdrErrors.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(lblHdrErrors)

    lblVisitorRuns.text = "0"
    lblVisitorRuns.fontSize = BBfontSize
    lblVisitorRuns.fontColor = SKColor.blackColor()
    lblVisitorRuns.position = CGPointMake(RUNS_OFFSET, 20.0)
    lblVisitorRuns.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(lblVisitorRuns)
    
    lblVisitorHits.text = "0"
    lblVisitorHits.fontSize = BBfontSize
    lblVisitorHits.fontColor = SKColor.blackColor()
    lblVisitorHits.position = CGPointMake(HITS_OFFSET, 20.0)
    lblVisitorHits.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(lblVisitorHits)
    
    lblVisitorErrors.text = "0"
    lblVisitorErrors.fontSize = BBfontSize
    lblVisitorErrors.fontColor = SKColor.blackColor()
    lblVisitorErrors.position = CGPointMake(ERRORS_OFFSET, 20.0)
    lblVisitorErrors.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(lblVisitorErrors)

    lblHomeName.text = ""
    lblHomeName.fontSize = BBfontSize
    lblHomeName.fontColor = SKColor.blackColor()
    lblHomeName.position = CGPointMake(10, 0.0)
    lblHomeName.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    addChild(lblHomeName)
    
    lblHomeRuns.text = "0"
    lblHomeRuns.fontSize = BBfontSize
    lblHomeRuns.fontColor = SKColor.blackColor()
    lblHomeRuns.position = CGPointMake(RUNS_OFFSET, 0.0)
    lblHomeRuns.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(lblHomeRuns)
    
    lblHomeHits.text = "0"
    lblHomeHits.fontSize = BBfontSize
    lblHomeHits.fontColor = SKColor.blackColor()
    lblHomeHits.position = CGPointMake(HITS_OFFSET, 0.0)
    lblHomeHits.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(lblHomeHits)
    
    lblHomeErrors.text = "0"
    lblHomeErrors.fontSize = BBfontSize
    lblHomeErrors.fontColor = SKColor.blackColor()
    lblHomeErrors.position = CGPointMake(ERRORS_OFFSET, 0.0)
    lblHomeErrors.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(lblHomeErrors)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder) has not been implemented")
  }
  
  func setGame(game:BBGame) {
    self.game = game
    lblVisitorName.text = "\(game.visitor.name)"
    lblHomeName.text = "\(game.home.name)"

    for node in lblVisitorScore {
      node.text = ""
    }
    for node in lblHomeScore {
      node.text = ""
    }
    lblVisitorRuns.text = ""
    lblVisitorHits.text = ""
    lblHomeErrors.text = ""
    lblHomeRuns.text = ""
    lblHomeHits.text = ""
    lblHomeErrors.text = ""
  }
  
  private func setScore(hide:Bool) {
    
    for node in lblVisitorScore {
      node.hidden = hide
    }
    for node in lblHomeScore {
      node.hidden = hide
    }
    lblVisitorRuns.hidden = hide
    lblVisitorHits.hidden = hide
    lblVisitorErrors.hidden = hide
    lblHomeRuns.hidden = hide
    lblHomeHits.hidden = hide
    lblHomeErrors.hidden = hide
  }
  
  func hideScore() {
    setScore(true)
  }

  func showScore() {
    setScore(false)
  }

  func updateScore() {
    // update box score
    var index:Int = 0
    for score in game!.visitor.innings {
      lblVisitorScore[index++].text = "\(score)"
    }
    index = 0
    for score in game!.home.innings {
      lblHomeScore[index++].text = score == -1 ? "x" : "\(score)"
    }
    lblVisitorRuns.text = "\(game!.visitor.runs)"
    lblVisitorHits.text = "\(game!.visitor.hits)"
    lblHomeErrors.text = "\(game!.visitor.errors)"
    lblHomeRuns.text = "\(game!.home.runs)"
    lblHomeHits.text = "\(game!.home.hits)"
    lblHomeErrors.text = "\(game!.home.errors)"
    showScore()
  }
}
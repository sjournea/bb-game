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
let LABEL_X_OFFSET:CGFloat = 45.0
let VISITOR_X_OFFSET:CGFloat = 25.0
let HOME_X_OFFSET:CGFloat = 5.0
let NUM_INNINGS_DISPLAYED:Int = 7

class ScoreBoard : SKSpriteNode {
  
  let bgColor:UIColor = UIColor.blackColor()
  let txtColor:SKColor = SKColor.whiteColor()
  
  var game:BBGame?
  let lblVisitorName = SKLabelNode(fontNamed: "Copperplate")
  let lblHomeName = SKLabelNode(fontNamed: "Copperplate")
  var lblHeaderScore:[SKLabelNode] = []
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
  var inningIndex:Int = 0
  
  init(size:CGSize) {
    super.init( texture:nil, color:bgColor, size:size)
    
    var xOffset:CGFloat = INNINGS_OFFSET
    for i in 1...7 {
      addInning(i, xOffset: xOffset)
      xOffset += INNINGS_INCREMENT
    }

    lblVisitorName.text = ""
    lblVisitorName.fontSize = BBfontSize
    lblVisitorName.fontColor = txtColor
    lblVisitorName.position = CGPointMake(10, VISITOR_X_OFFSET)
    lblVisitorName.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    addChild(lblVisitorName)
    
    lblHdrRuns.text = "R"
    lblHdrRuns.fontSize = BBfontSize
    lblHdrRuns.fontColor = txtColor
    lblHdrRuns.position = CGPointMake(RUNS_OFFSET, LABEL_X_OFFSET)
    lblHdrRuns.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(lblHdrRuns)
    
    lblHdrHits.text = "H"
    lblHdrHits.fontSize = BBfontSize
    lblHdrHits.fontColor = txtColor
    lblHdrHits.position = CGPointMake(HITS_OFFSET, LABEL_X_OFFSET)
    lblHdrHits.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(lblHdrHits)
    
    lblHdrErrors.text = "E"
    lblHdrErrors.fontSize = BBfontSize
    lblHdrErrors.fontColor = txtColor
    lblHdrErrors.position = CGPointMake(ERRORS_OFFSET, LABEL_X_OFFSET)
    lblHdrErrors.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(lblHdrErrors)

    lblVisitorRuns.text = "0"
    lblVisitorRuns.fontSize = BBfontSize
    lblVisitorRuns.fontColor = txtColor
    lblVisitorRuns.position = CGPointMake(RUNS_OFFSET, VISITOR_X_OFFSET)
    lblVisitorRuns.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(lblVisitorRuns)
    
    lblVisitorHits.text = "0"
    lblVisitorHits.fontSize = BBfontSize
    lblVisitorHits.fontColor = txtColor
    lblVisitorHits.position = CGPointMake(HITS_OFFSET, VISITOR_X_OFFSET)
    lblVisitorHits.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(lblVisitorHits)
    
    lblVisitorErrors.text = "0"
    lblVisitorErrors.fontSize = BBfontSize
    lblVisitorErrors.fontColor = txtColor
    lblVisitorErrors.position = CGPointMake(ERRORS_OFFSET, VISITOR_X_OFFSET)
    lblVisitorErrors.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(lblVisitorErrors)

    lblHomeName.text = ""
    lblHomeName.fontSize = BBfontSize
    lblHomeName.fontColor = txtColor
    lblHomeName.position = CGPointMake(10, HOME_X_OFFSET)
    lblHomeName.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    addChild(lblHomeName)
    
    lblHomeRuns.text = "0"
    lblHomeRuns.fontSize = BBfontSize
    lblHomeRuns.fontColor = txtColor
    lblHomeRuns.position = CGPointMake(RUNS_OFFSET, HOME_X_OFFSET)
    lblHomeRuns.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(lblHomeRuns)
    
    lblHomeHits.text = "0"
    lblHomeHits.fontSize = BBfontSize
    lblHomeHits.fontColor = txtColor
    lblHomeHits.position = CGPointMake(HITS_OFFSET, HOME_X_OFFSET )
    lblHomeHits.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(lblHomeHits)
    
    lblHomeErrors.text = "0"
    lblHomeErrors.fontSize = BBfontSize
    lblHomeErrors.fontColor = txtColor
    lblHomeErrors.position = CGPointMake(ERRORS_OFFSET, HOME_X_OFFSET)
    lblHomeErrors.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(lblHomeErrors)
  }
  
  private func addInning(inning:Int, xOffset:CGFloat) {

    let node = SKLabelNode(fontNamed: "Copperplate")
    node.text = "\(inning)"
    node.fontSize = BBfontSize
    node.fontColor = txtColor
    node.position = CGPointMake(xOffset, LABEL_X_OFFSET)
    node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(node)
    lblHeaderScore.append(node)
    
    let vis = SKLabelNode(fontNamed: "Copperplate")
    vis.text = ""
    vis.fontSize = BBfontSize
    vis.fontColor = txtColor
    vis.position = CGPointMake(xOffset, VISITOR_X_OFFSET)
    vis.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(vis)
    lblVisitorScore.append(vis)
    
    let hom = SKLabelNode(fontNamed: "Copperplate")
    hom.text = ""
    hom.fontSize = BBfontSize
    hom.fontColor = txtColor
    hom.position = CGPointMake(xOffset, HOME_X_OFFSET)
    hom.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    addChild(hom)
    lblHomeScore.append(hom)
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

    // reset headers
    for var i = 0; i < NUM_INNINGS_DISPLAYED; i++ {
      lblHeaderScore[i].text = "\(i + 1)"
    }
    // reset inningIndex
    inningIndex = 0
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
    var inning_index:Int = inningIndex
    for var i = 0; i < NUM_INNINGS_DISPLAYED; i++ {
      if game!.visitor.innings.count > inning_index {
        lblVisitorScore[i].text = "\(game!.visitor.innings[inning_index])"
      }
      if game!.home.innings.count > inning_index {
        let score = game!.home.innings[inning_index]
        lblHomeScore[i].text = score == -1 ? "x" : "\(score)"
      }
      inning_index++
    }
    lblVisitorRuns.text = "\(game!.visitor.runs)"
    lblVisitorHits.text = "\(game!.visitor.hits)"
    lblVisitorErrors.text = "\(game!.visitor.errors)"
    lblHomeRuns.text = "\(game!.home.runs)"
    lblHomeHits.text = "\(game!.home.hits)"
    lblHomeErrors.text = "\(game!.home.errors)"
    showScore()
  }

  func addExtraInning(inning:Int) {
    // determine inningIndex
    inningIndex = inning - 7
    // update headers
    for var i = 0; i < NUM_INNINGS_DISPLAYED; i++ {
      lblHeaderScore[i].text = "\(inningIndex + i + 1)"
    }
    // need to clear the last home inning position
    lblHomeScore[6].text = ""
  }
}
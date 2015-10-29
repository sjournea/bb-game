//
//  BBSummary.swift
//  BBGame
//
//  Created by Steven Journeay on 10/28/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation
import SpriteKit

class BBSummary : SKSpriteNode {
    
  var game:BBGame?
  var first:SKShapeNode?
  var second:SKShapeNode?
  var third:SKShapeNode?
  var out_1:SKShapeNode?
  var out_2:SKShapeNode?

  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder) has not been implemented")
  }
  
  init(size:CGSize) {
    super.init( texture:nil, color:SUMMARY_BACKGROUND_COLOR, size:size)

    let rect:CGRect = CGRect(x:0.0, y:0.0, width:10, height:10)
    
    first = SKShapeNode(rect:rect)
    first!.position = CGPointMake(40.0, 20.0)
    addChild(first!)
    second = SKShapeNode(rect:rect)
    second!.position = CGPointMake(25.0, 32.0)
    addChild(second!)
    third = SKShapeNode(rect:rect)
    third!.position = CGPointMake(10.0, 20.0)
    addChild(third!)
    out_1 = SKShapeNode(circleOfRadius: 5.0 )
    out_1!.position = CGPointMake(22.0, 10.0)
    addChild(out_1!)
    out_2 = SKShapeNode(circleOfRadius: 5.0 )
    out_2!.position = CGPointMake(38.0, 10.0)
    addChild(out_2!)
  }

  func setGame(game:BBGame) {
    self.game = game
  }
  
  func inningStart() {
    first!.fillColor = SKColor.clearColor()
    second!.fillColor = SKColor.clearColor()
    third!.fillColor = SKColor.clearColor()
    out_1!.fillColor = SKColor.clearColor()
    out_2!.fillColor = SKColor.clearColor()
  }
  
  func setOuts(outs:Int) {
    if outs > 0 {
      out_1!.fillColor = SKColor.redColor()
    }
    if outs > 1 {
      out_2!.fillColor = SKColor.redColor()
    }
  }
  
  func runnersAdvance(dct:[String:AnyObject]) {
    // clear all bases
    first!.fillColor = SKColor.clearColor()
    second!.fillColor = SKColor.clearColor()
    third!.fillColor = SKColor.clearColor()
    
    for obj in dct.values {
      if let base = obj as? String {
        if base == "1B" {
          first!.fillColor = SKColor.yellowColor()
        }
        if base == "2B" {
          second!.fillColor = SKColor.yellowColor()
        }
        if base == "3B" {
          third!.fillColor = SKColor.yellowColor()
        }
      }
    }
  }
  
}


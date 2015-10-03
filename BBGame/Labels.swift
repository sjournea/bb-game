//
//  Labels.swift
//  BBGame
//
//  Created by Steven Journeay on 10/3/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation
import SpriteKit

enum LabelPosition {
  case Center,
  Left
}

class Labels : SKSpriteNode {
  let bgColor: UIColor = UIColor.yellowColor()
  let txtColor: SKColor = SKColor.blackColor()
  
//  var game:BBGame?
  var lstLabels:[SKLabelNode] = []
  var num:Int = 0
    
  init(size:CGSize, num:Int) {
    super.init( texture:nil, color:bgColor, size:size)
    
    self.num = num
    addLabelNodes()
    
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder) has not been implemented")
  }

  private func addLabelNodes() {
    
    for _ in 1...num {
      
      let node = SKLabelNode(fontNamed: "Copperplate")
      node.text = ""
      node.fontSize = BBfontSize
      node.fontColor = txtColor
      node.hidden = true

      addChild(node)
      lstLabels.append(node)
      
    }
  }
  
  func hideLabels() {
    for lblNode in lstLabels {
      lblNode.hidden = true
    }
  }
  
  func updateLabelNode(idx:Int, text:String, ham:LabelPosition = LabelPosition.Left ) {
    
    let node = lstLabels[idx]
    node.text = text
    let yOffset:CGFloat = size.height - CGFloat(idx+1)*(BBfontSize+1.0)
    switch ham {
      case .Left:
        node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        node.position = CGPointMake(30.0, yOffset)
      case .Center:
        node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        node.position = CGPointMake(scene!.size.width/2.0, yOffset)
    }
    node.hidden = false
  }

}




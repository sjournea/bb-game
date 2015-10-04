//
//  Button.swift
//  BBGame
//
//  Created by Steven Journeay on 10/3/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation
import SpriteKit

class TLButton: SKNode {
  let txtColor = SKColor.blackColor()

  var defaultButton: SKSpriteNode
  var activeButton: SKSpriteNode
  var action: () -> Void
    
  init(size:CGSize, defaultColor:SKColor, activeColor:SKColor, label:String, buttonAction: () -> Void) {

    
    //defaultButton = SKSpriteNode(imageNamed: defaultButtonImage)
    //activeButton = SKSpriteNode(imageNamed: activeButtonImage)
    defaultButton = SKSpriteNode(texture:nil, color:defaultColor, size:size)
    defaultButton.anchorPoint = CGPoint(x:0.0, y:0.0)  // Lower right

    activeButton = SKSpriteNode(texture:nil, color:activeColor, size:size)
    activeButton.anchorPoint = CGPoint(x:0.0, y:0.0)  // Lower right
    activeButton.hidden = true
    action = buttonAction
    
    super.init()
    
    userInteractionEnabled = true
    addChild(defaultButton)
    addChild(activeButton)
    
    if label != "" {
      let lbl = SKLabelNode(fontNamed: "Copperplate")
      lbl.text = label
      lbl.fontSize = BBfontSize
      lbl.fontColor = txtColor
      lbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
      lbl.position = CGPointMake(size.width/2.0, size.height/2.0)
      
      defaultButton.addChild(lbl)
    }
  }
    
  // Required so XCode doesn't throw warnings
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    activeButton.hidden = false
    defaultButton.hidden = true
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let touch: UITouch = touches.first!
    let location: CGPoint = touch.locationInNode(self)
    
    if defaultButton.containsPoint(location) {
      action()
    }
    
    activeButton.hidden = true
    defaultButton.hidden = false
  }
}
  
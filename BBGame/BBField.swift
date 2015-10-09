//
//  BBField.swift
//  BBGame
//
//  Created by Steven Journeay on 10/4/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation
import SpriteKit

class BBField : SKSpriteNode {
  let BG_COLOR = UIColor.whiteColor()
  let BASE_EMPTY_COLOR = UIColor.whiteColor()
  let BASE_OCCUPY_COLOR = UIColor.redColor()
  
//  var diamond:SKShapeNode?
  var home:SKShapeNode?
  var firstBase:SKShapeNode?
  var secondBase:SKShapeNode?
  var thirdBase:SKShapeNode?
  var stickMan:BBStickMan?
  
  var game:BBGame?
  
  init(size:CGSize) {
      
    super.init( texture:nil, color:BG_COLOR, size:size)
    
    home = SKShapeNode(circleOfRadius: 30.0)
    home!.fillColor = UIColor.redColor()
    home!.position = CGPointMake(size.width/2.0, 40.0)
    addChild(home!)

    firstBase = SKShapeNode(circleOfRadius: 30.0)
    firstBase!.fillColor = UIColor.redColor()
    firstBase!.position = CGPointMake(size.width-40.0, size.height / 2.0)
    addChild(firstBase!)

    secondBase = SKShapeNode(circleOfRadius: 30.0)
    secondBase!.fillColor = UIColor.redColor()
    secondBase!.position = CGPointMake(size.width/2.0, size.height - 40.0)
    addChild(secondBase!)

    thirdBase = SKShapeNode(circleOfRadius: 30.0)
    thirdBase!.fillColor = UIColor.redColor()
    thirdBase!.position = CGPointMake(40.0, size.height / 2.0)
    addChild(thirdBase!)
    
    stickMan = BBStickMan()
    stickMan!.position = CGPointMake(size.width/2.0, 40.0)
    addChild(stickMan!)
  }

  func setGame(game:BBGame) {
    self.game = game
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder) has not been implemented")
  }
}



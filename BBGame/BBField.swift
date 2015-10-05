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
    
  var game:BBGame?
  
  init() {
    let texture = SKTexture(imageNamed:"Field")
    super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    
  }

  func setGame(game:BBGame) {
    self.game = game
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder) has not been implemented")
  }
}



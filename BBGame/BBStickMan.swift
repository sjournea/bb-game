//
//  BBStickMan.swift
//  BBGame
//
//  Created by Steven Journeay on 10/6/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation
import SpriteKit

class BBStickMan : SKSpriteNode {

  init() {
    let texture = SKTexture(imageNamed: "stickman")
    super.init(texture: texture,
                 color: UIColor.clearColor(),
                 size: texture.size())
    }

  required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
}



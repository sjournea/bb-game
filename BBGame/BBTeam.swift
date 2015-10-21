//
//  BBTeam.swift
//  BBGame
//
//  Created by Steven Journeay on 10/3/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class BBTeam : Team {
  var color:UIColor?
  
  init(name:String="", color:UIColor = .whiteColor(), home:Bool, robot:Bool=false) {
    super.init(name:name, home:home, robot:robot)
    self.color = color
  }
  
  func pickSelection(game:Game) -> Int {
    // pick one of the available selections
    let lst:[Int] = game.avail()
    // using random pick
    let dist = GKRandomDistribution(lowestValue: 0, highestValue: lst.count - 1)
    return lst[dist.nextInt()]
  }
}
//
//  BBTeam.swift
//  BBGame
//
//  Created by Steven Journeay on 10/3/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation
import SpriteKit

class BBTeam : Team {
  var color:UIColor?

  init(name:String="", color:UIColor = .whiteColor(), robot:Bool=false) {
    super.init(name:name, robot:robot)
    self.color = color
  }
}
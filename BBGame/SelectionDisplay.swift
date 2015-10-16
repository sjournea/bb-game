//
//  SelectionDisplay.swift
//  BBGame
//
//  Created by Steven Journeay on 10/15/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation
import SpriteKit

class SelectionDisplay : SKSpriteNode {

  let BACKGROUND_COLOR = UIColor.whiteColor()
  
  var game:BBGame?
  var testButtons:TestButtons?
  var selectionButtons:[SelectionButton] = []
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder) has not been implemented")
  }
  
  init(size:CGSize) {
    super.init( texture:nil, color:BACKGROUND_COLOR, size:size)
    
    testButtons = TestButtons(size: CGSize(width:size.width, height:50))
    testButtons!.position = CGPointMake(0.0, 0.0)
    testButtons!.anchorPoint = CGPoint(x:0.0, y:0.0)  // Lower right
    addChild(testButtons!)
  }
  
  private func createSelectionButtons() {
    selectionButtons.removeAll()
//    for sel in game!.lstSelections {
//        let button = SelectionButton(selection: <#T##Selection#>, buttonAction: <#T##() -> Void#>)
//    }
  }
  
  func setGame(game:BBGame) {
    self.game = game
    testButtons!.setGame(game)
    
    
  }
  
  func enableSelection(enable:Bool) {
    self.hidden = !enable
  }
}



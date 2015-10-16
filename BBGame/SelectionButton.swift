//
//  SelectionButton.swift
//  BBGame
//
//  Created by Steven Journeay on 10/15/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation
import SpriteKit

class SelectionButton : TLButton {
  let SELECTION_BUTTON_WIDTH = 30
  let SELECTION_BUTTON_HEIGHT = 30
  let SELECTION_DEFAULT_COLOR = SKColor.blueColor()
  let SELECTION_ACTIVE_COLOR = SKColor.redColor()
  
  init( selection: Selection, buttonAction : (AnyObject?) -> Void) {
    super.init( size:CGSize(width:SELECTION_BUTTON_WIDTH, height:SELECTION_BUTTON_HEIGHT),
                defaultColor:SELECTION_DEFAULT_COLOR,
                activeColor:SELECTION_ACTIVE_COLOR,
                label:selection.isUsed() ? selection.desc : "??",
                buttonAction:buttonAction)
        
  }
  
  // Required so XCode doesn't throw warnings
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
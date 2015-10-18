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
  
  var selection:Selection
  
  init( size:CGSize,
        selection: Selection,
        buttonAction : (TLButton) -> Void) {
    self.selection = selection
    super.init( size:size,
                defaultColor:SELECTION_DEFAULT_COLOR,
                activeColor:SELECTION_ACTIVE_COLOR,
                label:selection.isUsed() ? selection.desc : "??",
                buttonAction:buttonAction)
        
  }
  
  // Required so XCode doesn't throw warnings
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setUsed() {
    lbl.text = selection.desc
    defaultButton.color = SELECTION_USED_COLOR
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    // if selection has already been used then do nothing
    if !selection.isUsed() {
      activate()
    }
  }

}
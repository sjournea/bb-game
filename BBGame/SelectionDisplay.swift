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
    
    if DEBUG_USE_TEST_BUTTONS {
      testButtons = TestButtons(size: CGSize(width:size.width, height:50))
      testButtons!.position = CGPointMake(0.0, 0.0)
      testButtons!.anchorPoint = CGPoint(x:0.0, y:0.0)  // Lower right
      addChild(testButtons!)
    }
  }
  
  private func createSelectionButtons() {
    // remove all existing selection buttons
    selectionButtons.removeAll()

    // add new Selection buttons
    // Add in order
    //   0 ... 9
    //  10 ... 19
    //     ...
    //  90 ... 99
    var yOffset:CGFloat = self.size.height
    for (index,select) in game!.lstSelections.enumerate() {
      let sel = select as! BBSelection
      let multiplier = index % 10
      if multiplier == 0 {
        yOffset -= (SELECTION_BUTTON_HEIGHT + SELECTION_BUTTON_SPACING)
      }
      
      // create SelectionButton
      let button = SelectionButton(size:SELECTION_BUTTON_SIZE, selection: sel, buttonAction: selectButtonAction)
      let xOffset:CGFloat = CGFloat(multiplier) * (SELECTION_BUTTON_WIDTH + SELECTION_BUTTON_SPACING) + SELECTION_BUTTON_EDGE
      button.position = CGPointMake(xOffset, yOffset)

      // Add button to SelectionDisplay and save in selectButtons array
      addChild(button)
      selectionButtons.append(button)

      // Add button to BBSelection
      sel.button = button
    }
  }
  
  func selectButtonAction(button:TLButton) {
    let but = button as! SelectionButton
    game!.makeSelection = false
    game!.in_play(but.selection.index)
  }
  
  func setGame(game:BBGame) {
    self.game = game
    if DEBUG_USE_TEST_BUTTONS {
      testButtons!.setGame(game)
    }
    createSelectionButtons()
  }
  
  func enableSelection(enable:Bool) {
    self.hidden = !enable
  }
}



//
//  BBSelections.swift
//  BBGame
//
//  Created by Steven Journeay on 10/19/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation

class BBSelection : Selection {

  var button: SelectionButton?
  
  override func Used(team:Team) {
    // call super
    super.Used(team)
    // 
    if let but = button {
      let color = team.isVisitor() ? SELECTION_VISITOR_USED_COLOR : SELECTION_HOME_USED_COLOR
      but.setUsed(color)
    }
  }
  

  
}

func CreateBBSelection(index:Int, bb:BB) -> Selection {
    return BBSelection(sel:bb, index:index)
}

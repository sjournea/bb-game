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
  
}

func CreateBBSelection(index:Int, bb:BB) -> Selection {
    return BBSelection(sel:bb, index:index)
}

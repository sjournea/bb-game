//
//  TestButtons.swift
//  BBGame
//
//  Created by Steven Journeay on 10/3/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation
import SpriteKit

class TestButtons : SKSpriteNode {
  let BG_COLOR = UIColor.grayColor()
  let BUTTON_SCALE_WIDTH:CGFloat = 1.0/6.0  // 1/6
  let NO_MORE_AVAIL_COLOR = SKColor.grayColor()
  
  var game:BBGame?
  var homeRunButton: TLButton?
  var tripleButton: TLButton?
  var doubleButton: TLButton?
  var singleButton: TLButton?
  var outButton: TLButton?
  var errorButton: TLButton?
  
  init(size:CGSize) {
    super.init( texture:nil, color:BG_COLOR, size:size)
    
    homeRunButton = TLButton(size:CGSize(width: size.width*BUTTON_SCALE_WIDTH, height: size.height), buttonAction: homeRun,
      defaultColor: TEST_BUTTON_HOME_RUN_COLOR, activeColor: SKColor.redColor(), label:"HR")
    homeRunButton!.position = CGPointMake(0.0, 0.0)
    addChild(homeRunButton!)
    
    tripleButton = TLButton(size:CGSize(width: size.width*BUTTON_SCALE_WIDTH, height: size.height), buttonAction: triple,
      defaultColor: TEST_BUTTON_TRIPLE_COLOR, activeColor: SKColor.redColor(), label:"3B")
    tripleButton!.position = CGPointMake(size.width*BUTTON_SCALE_WIDTH, 0.0)
    addChild(tripleButton!)

    doubleButton = TLButton(size:CGSize(width: size.width*BUTTON_SCALE_WIDTH, height: size.height), buttonAction: double,
      defaultColor: TEST_BUTTON_DOUBLE_COLOR, activeColor: SKColor.redColor(), label:"2B")
    doubleButton!.position = CGPointMake(2*size.width*BUTTON_SCALE_WIDTH, 0.0)
    addChild(doubleButton!)

    singleButton = TLButton(size:CGSize(width: size.width*BUTTON_SCALE_WIDTH, height: size.height), buttonAction: single,
      defaultColor: TEST_BUTTON_SINGLE_COLOR, activeColor: SKColor.redColor(), label:"1B")
    singleButton!.position = CGPointMake(3*size.width*BUTTON_SCALE_WIDTH, 0.0)
    addChild(singleButton!)

    outButton = TLButton(size:CGSize(width: size.width*BUTTON_SCALE_WIDTH, height: size.height), buttonAction: out,
      defaultColor: TEST_BUTTON_OUT_COLOR, activeColor: SKColor.redColor(), label:"OUT")
    outButton!.position = CGPointMake(4*size.width*BUTTON_SCALE_WIDTH, 0.0)
    addChild(outButton!)

    errorButton = TLButton(size:CGSize(width: size.width*BUTTON_SCALE_WIDTH, height: size.height), buttonAction: error, defaultColor: TEST_BUTTON_RANDOM_COLOR, activeColor: SKColor.redColor(), label:"ERR")
    errorButton!.position = CGPointMake(5*size.width*BUTTON_SCALE_WIDTH, 0.0)
    addChild(errorButton!)
  }
    
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder) has not been implemented")
  }
  
  func setGame(game:BBGame) {
    self.game = game
  }
  
  func enableSelection(enable:Bool) {
    self.hidden = !enable
  }
  
  private func findSelection(bb:BB) -> [Int] {
    let lstAvail:[Int] = game!.avail()
    var lstTypeAvail:[Int] = []
    for index in lstAvail {
      let selection = game!.lstSelections[index]
      if selection.sel == bb {
        lstTypeAvail.append(index)
      }
    }
    return lstTypeAvail
  }

  func homeRun(button:TLButton) {
    print("HOME RUN")
    let lst = findSelection(BB.HOMERUN)
    if lst.count > 0 {
      game!.in_play(lst[0])
      game!.makeSelection = false
      if lst.count == 1 {
        // No more homeruns
        button.defaultButton.color = NO_MORE_AVAIL_COLOR
      }
    } else {
      print("*** No HOME_RUNS found ***")
    }
  }

  func triple(button:TLButton) {
    print("TRIPLE")
    let lst = findSelection(BB.TRIPLE)
    if lst.count > 0 {
      game!.in_play(lst[0])
      game!.makeSelection = false
      if lst.count == 1 {
        // No more
        button.defaultButton.color = NO_MORE_AVAIL_COLOR
      }
    } else {
      print("*** No TRIPLES found ***")
    }
  }

  func double(button:TLButton) {
    print("DOUBLE")
    let lst = findSelection(BB.DOUBLE)
    if lst.count > 0 {
      game!.in_play(lst[0])
      game!.makeSelection = false
      if lst.count == 1 {
        // No more
        button.defaultButton.color = NO_MORE_AVAIL_COLOR
      }
    } else {
      print("*** No DOUBLES found ***")
    }
  }
  
  func single(button:TLButton) {
    print("SINGLE")
    let lst = findSelection(BB.SINGLE)
    if lst.count > 0 {
      game!.in_play(lst[0])
      game!.makeSelection = false
      if lst.count == 1 {
        // No more
        button.defaultButton.color = NO_MORE_AVAIL_COLOR
      }
    } else {
      print("*** No SINGLES found ***")
    }
  }
  
  func out(button:TLButton) {
    print("OUT")
    let lst = findSelection(BB.OUT)
    if lst.count > 0 {
      game!.in_play(lst[0])
      game!.makeSelection = false
      if lst.count == 1 {
        // No more
        button.defaultButton.color = NO_MORE_AVAIL_COLOR
      }
    } else {
      print("*** No OUTS found ***")
    }
  }
  
  func error(button:TLButton) {
    print("Error")
    let lstAvail:[Int] = game!.avail()
    for index in lstAvail {
      let selection = game!.lstSelections[index]
      if selection.sel == BB.OUT {
        selection.sel = BB.ERROR_1B
        game!.in_play(index)
        game!.makeSelection = false
        break
      }
    }
  }

}


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
  
  var game:BBGame?
  var homeRunButton: TLButton?
  var tripleButton: TLButton?
  var doubleButton: TLButton?
  var singleButton: TLButton?
  var outButton: TLButton?
  var nextAvailButton: TLButton?
  
  init(size:CGSize) {
    super.init( texture:nil, color:BG_COLOR, size:size)
    
    homeRunButton = TLButton(size:CGSize(width: size.width*BUTTON_SCALE_WIDTH, height: size.height),
      defaultColor: SKColor.blueColor(), activeColor: SKColor.redColor(), label:"HR", buttonAction: homeRun)
    homeRunButton!.position = CGPointMake(0.0, 0.0)
    addChild(homeRunButton!)
    
    tripleButton = TLButton(size:CGSize(width: size.width*BUTTON_SCALE_WIDTH, height: size.height),
      defaultColor: SKColor.yellowColor(), activeColor: SKColor.redColor(), label:"3B", buttonAction: triple)
    tripleButton!.position = CGPointMake(size.width*BUTTON_SCALE_WIDTH, 0.0)
    addChild(tripleButton!)

    doubleButton = TLButton(size:CGSize(width: size.width*BUTTON_SCALE_WIDTH, height: size.height),
      defaultColor: SKColor.greenColor(), activeColor: SKColor.redColor(), label:"2B", buttonAction: double)
    doubleButton!.position = CGPointMake(2*size.width*BUTTON_SCALE_WIDTH, 0.0)
    addChild(doubleButton!)

    singleButton = TLButton(size:CGSize(width: size.width*BUTTON_SCALE_WIDTH, height: size.height),
      defaultColor: SKColor.orangeColor(), activeColor: SKColor.redColor(), label:"1B", buttonAction: single)
    singleButton!.position = CGPointMake(3*size.width*BUTTON_SCALE_WIDTH, 0.0)
    addChild(singleButton!)

    outButton = TLButton(size:CGSize(width: size.width*BUTTON_SCALE_WIDTH, height: size.height),
      defaultColor: SKColor.purpleColor(), activeColor: SKColor.redColor(), label:"OUT", buttonAction: out)
    outButton!.position = CGPointMake(4*size.width*BUTTON_SCALE_WIDTH, 0.0)
    addChild(outButton!)

    nextAvailButton = TLButton(size:CGSize(width: size.width*BUTTON_SCALE_WIDTH, height: size.height),
      defaultColor: SKColor.brownColor(), activeColor: SKColor.redColor(), label:"?", buttonAction: nextAvail)
    nextAvailButton!.position = CGPointMake(5*size.width*BUTTON_SCALE_WIDTH, 0.0)
    addChild(nextAvailButton!)
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
  

  private func findSelection(bb:BB) -> Bool {
    let lstAvail:[Int] = game!.avail()
    for index in lstAvail {
      let selection = game!.lstSelections.get_item(index)
      if selection.sel == bb {
        game!.in_play(index)
        game!.makeSelection = false
        return true
      }
    }
    return false
  }
  
  func homeRun() {
    print("HOME RUN")
    if !findSelection(BB.HOMERUN) {
      print("*** No HOME_RUNS found ***")
    }
  }

  func triple() {
    print("TRIPLE")
    if !findSelection(BB.TRIPLE) {
      print("*** No TRIPLES found ***")
    }
  }

  func double() {
    print("DOUBLE")
    if !findSelection(BB.DOUBLE) {
      print("*** No DOUBLES found ***")
    }
  }
  
  func single() {
    print("SINGLE")
    if !findSelection(BB.SINGLE) {
      print("*** No SINGLES found ***")
    }
  }
  
  func out() {
    print("OUT")
    if !findSelection(BB.OUT) {
      print("*** No OUTS found ***")
    }
  }
  
  func nextAvail() {
    print("NEXT AVAILABLE")
    let idx = game!.avail()[0]
    game!.in_play(idx)
    game!.makeSelection = false

  }
}


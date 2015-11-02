//
//  common.swift
//  BBGame
//
//  Created by Steven Journeay on 10/18/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import SpriteKit

let BUTTON_ACTIVE_COLOR = SKColor.redColor()

let BBfontSize:CGFloat = 19
let BUTTON_FONT_SIZE:CGFloat = 13

let SELECTION_BUTTON_WIDTH:CGFloat = 28.0
let SELECTION_BUTTON_HEIGHT:CGFloat = 28.0
let SELECTION_BUTTON_SPACING:CGFloat = 8.0
let SELECTION_BUTTON_EDGE:CGFloat = 10.0
let SELECTION_BUTTON_SIZE:CGSize = CGSize(width: SELECTION_BUTTON_WIDTH, height: SELECTION_BUTTON_HEIGHT)

let SELECTION_DEFAULT_COLOR = SKColor.grayColor()
let SELECTION_ACTIVE_COLOR = BUTTON_ACTIVE_COLOR
let SELECTION_HOME_USED_COLOR = SKColor.orangeColor()
let SELECTION_VISITOR_USED_COLOR = SKColor.yellowColor()

let TEST_BUTTON_HOME_RUN_COLOR = SKColor.blueColor()
let TEST_BUTTON_TRIPLE_COLOR = SKColor.yellowColor()
let TEST_BUTTON_DOUBLE_COLOR = SKColor.greenColor()
let TEST_BUTTON_SINGLE_COLOR = SKColor.orangeColor()
let TEST_BUTTON_OUT_COLOR = SKColor.purpleColor()
let TEST_BUTTON_RANDOM_COLOR = SKColor.brownColor()
let TEST_BUTTON_ACTIVE_COLOR = BUTTON_ACTIVE_COLOR

// MenuScene constants
let MENU_BUTTON_WIDTH:CGFloat = 200.0
let MENU_BUTTON_HEIGHT:CGFloat = 100.0
let MENU_BUTTON_COLOR = SKColor.greenColor()

// Delay in seconds when displaying events
let GAME_DELAY:Int64 = 1

// BBField constants
let BASE_COLOR = UIColor.whiteColor()
let BASE_OCCUPY_COLOR = UIColor.redColor()
let RUNNER_ADVANCE_DURATION:Double = 1.0  // 1 second

// BBSummary constants
let SUMMARY_BACKGROUND_COLOR = UIColor.blackColor()

let DEBUG_USE_TEST_BUTTONS = false

extension Int
{
  func loByte() -> UInt8 { return UInt8(self & 0xFF) }
  func hiByte() -> UInt8 { return UInt8((self >> 8) & 0xFF) }
  func loWord() -> Int16 { return Int16(self & 0xFFFF) }
  func hiWord() -> Int16 { return Int16((self >> 16) & 0xFFFF) }
}

extension Int16
{
  func loByte() -> UInt8 { return UInt8(self & 0xFF) }
  func hiByte() -> UInt8 { return UInt8((self >> 8) & 0xFF) }
}

extension UInt
{
  func loByte() -> UInt8 { return UInt8(self & 0xFF) }
  func hiByte() -> UInt8 { return UInt8((self >> 8) & 0xFF) }
  func loWord() -> UInt16 { return UInt16(self & 0xFFFF) }
  func hiWord() -> UInt16 { return UInt16((self >> 16) & 0xFFFF) }
}

extension UInt16
{
  func loByte() -> UInt8 { return UInt8(self & 0xFF) }
  func hiByte() -> UInt8 { return UInt8((self >> 8) & 0xFF) }
}

extension String {
  var length: Int { return characters.count }   // Swift 2.0
}

/*
protocol EnumerableEnum {
  init?(rawValue: Int)
  static func firstValue() -> Int
}

extension EnumerableEnum {
  static func enumerate() -> AnyGenerator<Self> {
    var nextIndex = firstRawValue()
    return anyGenerator { Self(rawValue: nextIndex++) }
  }
  static func firstRawValue() -> Int { return 0 }
}
*/

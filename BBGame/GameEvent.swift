//
//  GameEvent.swift
//  BBGame
//
//  Created by Steven Journeay on 11/3/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation

enum GameEvent: Int, CustomStringConvertible {
  
  case GameIdle,
  GameStart,  // visitor, home, start time
  GameEnd,
  SideRetired,
  AtBat,
  Out,
  Hit,
  Run,
  Error,
  Selection,
  InningStart,
  RunnerAdvance,
  GameInit,
  GameFinal,
  Walkoff
  
  var description : String {
    get {
      switch(self) {
      case GameIdle: return "GameIdle"
      case GameStart: return "GameStart"
      case GameEnd: return "GameEnd"
      case SideRetired: return "SideRetired"
      case AtBat: return "AtBat"
      case Out: return "Out"
      case Hit: return "Hit"
      case Run: return "Run"
      case Error: return "Error"
      case Selection: return "Selection"
      case InningStart: return "InningStart"
      case RunnerAdvance: return "RunnerAdvance"
      case GameInit: return "GameInit"
      case GameFinal: return "GameFinal"
      case Walkoff: return "Walkoff"
      }
    }
  }
}


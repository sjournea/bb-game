//
//  MenuScene.swift
//  BBGame
//
//  Created by Steven Journeay on 10/27/15.
//  Copyright © 2015 Taralaur Consultants, Inc. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {

  var btnStartGame: TLButton?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
    
  override init(size: CGSize) {
    super.init(size: size)
        
    backgroundColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
   
    btnStartGame = TLButton(size:CGSize(width: MENU_BUTTON_WIDTH, height: MENU_BUTTON_HEIGHT),
      buttonAction: startGame, defaultColor: MENU_BUTTON_COLOR, /* activeColor: BUTTON_ACTIVE_COLOR, */label:"Start Game", labelSize:26)
    btnStartGame!.position = CGPointMake((size.width - MENU_BUTTON_WIDTH) / 2.0 , 400.0)
    addChild(btnStartGame!)

  }


  func startGame(button:TLButton) {
    print("Start Game")
    
    let transition = SKTransition.crossFadeWithDuration(1.0)
    let gameScene = GameScene(size: size)
    view?.presentScene(gameScene, transition: transition)
  }

  
}
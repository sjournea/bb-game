//
//  GameViewController.swift
//  BBGame
//
//  Created by Steven Journeay on 9/29/15.
//  Copyright (c) 2015 Taralaur Consultants, Inc. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
  var scene: MenuScene!
    
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
    
  override func viewDidLoad() {
        
    super.viewDidLoad()
        
    // Configure the view.
    let skView = self.view as! SKView
    skView.showsFPS = true
    // skView.showsNodeCount = true
        
    scene = MenuScene(size: skView.bounds.size)
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    // skView.ignoresSiblingOrder = true
        
    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = .AspectFill
        
    skView.presentScene(scene)
  }
}

/*
override func shouldAutorotate() -> Bool {
return true
}

override func supportedInterfaceOrientations() -> Int {
if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
} else {
return Int(UIInterfaceOrientationMask.All.rawValue)
}
}

override func didReceiveMemoryWarning() {
super.didReceiveMemoryWarning()
// Release any cached data, images, etc that aren't in use.
}

override func prefersStatusBarHidden() -> Bool {
return true
}
}
*/


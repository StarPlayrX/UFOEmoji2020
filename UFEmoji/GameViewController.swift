//
//  GameViewController.swift
//  UF Emoji
//
//  Created by todd on 12/3/15.
//  Copyright (c) 2015 Todd Bruss. All rights reserved.
//

import UIKit
import SpriteKit

protocol GameProtocol {
    func runGameMenu()
    func runGameLevel()
}

var gameDelegate : GameProtocol?

class GameViewController: UIViewController, GameProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameDelegate = self

        UIApplication.shared.isStatusBarHidden = true
        view.backgroundColor = SKColor.init(displayP3Red: 0, green: 15 / 255, blue: 70 / 255, alpha: 1.0)

        //let defaults = UserDefaults.standard
       // let level = 1
   
        var tas = [SKTextureAtlas]()
    tas.append(SKTextureAtlas(named: "grass2"))
        tas.append(SKTextureAtlas(named: "dirt3"))

      //   Call the preload and in the completion handler load and start the GameScene:
    SKTextureAtlas.preloadTextureAtlases(tas, withCompletionHandler: {
            //do nothing

        })

        getDeviceSize()

        self.runGameMenu()

        
    }
	
    deinit {
        removeFromParent()
    }
    
    func runGameMenu() {
        if let scene = GameMenu(fileNamed:"GameMenu"),  let skView = self.view as? SKView {
            skView.scene?.removeAllActions()
            skView.scene?.removeAllChildren()
            skView.scene?.removeFromParent()
            
            skView.showsFPS = false
            skView.preferredFramesPerSecond = 60
            skView.showsNodeCount = false
            skView.showsPhysics = false
            skView.isMultipleTouchEnabled = true
            skView.isAsynchronous = true
            skView.ignoresSiblingOrder = true
            skView.clipsToBounds = true
            skView.scene?.scaleMode = .aspectFill
            scene.size = setSceneSizeForGame()
            scene.scaleMode = .aspectFill
            scene.backgroundColor = SKColor.init(displayP3Red: 0, green: 15 / 255, blue: 70 / 255, alpha: 1.0)
            skView.presentScene(scene)
        }
    }
    
    
    func runGameLevel() {
        if let scene = GameScene(fileNamed:"1"),  let skView = self.view as? SKView {
            skView.scene?.removeAllActions()
            skView.scene?.removeAllChildren()
            skView.scene?.removeFromParent()

            skView.showsFPS = false
            skView.preferredFramesPerSecond = 60
            skView.showsNodeCount = false
            skView.showsPhysics = false
            skView.isMultipleTouchEnabled = true
            skView.isAsynchronous = true
            skView.ignoresSiblingOrder = true
            skView.clipsToBounds = true
            skView.scene?.scaleMode = .aspectFill
            scene.size = setSceneSizeForGame()
            scene.scaleMode = .aspectFill
            scene.backgroundColor = .black
            skView.presentScene(scene)
        }
    }

    override var shouldAutorotate : Bool {
        return true
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .bottom
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
            return [.landscapeRight,.landscapeLeft]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
            return false
    }
    
    override var prefersStatusBarHidden: Bool {
            return true
    }

}

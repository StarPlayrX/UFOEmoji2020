//
//  GameViewController.swift
//  UF Emoji
//
//  Created by todd on 12/3/15.
//  Copyright (c) 2015 Todd Bruss. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isStatusBarHidden = true
        view.backgroundColor = UIColor.black

        //let defaults = UserDefaults.standard
       // let level = 1
   
        var tas = [SKTextureAtlas]()
        tas.append(SKTextureAtlas(named: "grass2"))
        tas.append(SKTextureAtlas(named: "dirt3"))

        // Call the preload and in the completion handler load and start the GameScene:
        SKTextureAtlas.preloadTextureAtlases(tas, withCompletionHandler: { 
            //do nothing

        })

        getDeviceSize()

        self.startScene()

        
    }

    func startScene() {
        
        if let scene = GameMenu(fileNamed:"GameMenu"),
            let skView = self.view as? SKView {
           
            skView.showsFPS = false
            skView.showsNodeCount = false
            skView.showsPhysics = false
            skView.isMultipleTouchEnabled = false
            skView.isAsynchronous = false
            skView.ignoresSiblingOrder = true
            skView.clipsToBounds = true
            scene.scaleMode = .aspectFill
            scene.size = setSceneSizeForGame()
            scene.backgroundColor = SKColor.black
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

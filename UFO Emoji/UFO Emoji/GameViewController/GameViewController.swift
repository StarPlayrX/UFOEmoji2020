//
//  GameViewController.swift
//  UFO Emoji
//
//  Created by Todd Bruss on 5/24/20.
//  Copyright © 2020 Todd Bruss. All rights reserved.
//

import UIKit
import SpriteKit

protocol GameProtocol: class {
    func runGameMenu()
    func runGameLevel()
}

class GameViewController: UIViewController, GameProtocol {
    
    func runGameMenu() {
        saveSettings()
        gameMenu()
    }
    
    func runGameLevel() {
        saveSettings()
        gameLevel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameDelegate = self
        saveSettings()
        gameMenu()
    }
    
    deinit {
        saveSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = .red
    }
    
    func gameMenu() {
        guard
            let view = self.view as? SKView,
            let scene = GameMenu(fileNamed: "GameMenu")
            else { return }
        
        DispatchQueue.main.async  { [weak view] in
            guard let view = view else { return }
            scene.size = setSceneSizeForMenu()
            
            scene.scaleMode = .aspectFill

            scene.backgroundColor = SKColor.init(displayP3Red: 0, green: 20 / 255, blue: 80 / 255, alpha: 1.0)
            view.isMultipleTouchEnabled = true
            view.allowsTransparency = false
            view.isAsynchronous = true
            view.isOpaque = true
            view.clipsToBounds = true
            view.ignoresSiblingOrder = true
           
            view.showsFPS = showsFPS
            view.showsNodeCount = showsNodeCount
            view.showsPhysics = showsPhysics
            view.showsFields = showsFields
            view.showsDrawCount = showsDrawCount
            view.showsQuadCount = showsQuadCount
            
            view.shouldCullNonVisibleNodes = true
            //view.preferredFramesPerSecond = 61
            view.presentScene(scene)

        }
    }
    
    func gameLevel() {
        guard
            let view = self.view as? SKView,
            let scene = GameScene(fileNamed: "GameScene")
            else {
                return
                
        }
        
        DispatchQueue.main.async  {  [weak view] in
            guard let view = view else { return }
            scene.size = setSceneSizeForGame()

            scene.scaleMode = .aspectFill

            scene.backgroundColor = SKColor.black
            view.isMultipleTouchEnabled = true
            view.allowsTransparency = false
            view.isAsynchronous = true
            view.backgroundColor = .black
            scene.backgroundColor = SKColor.init(displayP3Red: 0, green: 20 / 255, blue: 80 / 255, alpha: 0.25)

            view.isOpaque = true
            view.clipsToBounds = true
            view.ignoresSiblingOrder = true
            
            view.showsFPS = showsFPS
            view.showsNodeCount = showsNodeCount
            view.showsPhysics = showsPhysics
            view.showsFields = showsFields
            view.showsDrawCount = showsDrawCount
            view.showsQuadCount = showsQuadCount
            scene.anchorPoint = CGPoint(x: 1, y: 1)

            if #available(iOS 13.0, *) {
                view.showsLargeContentViewer = false
            } else {
                // Fallback on earlier versions
            }
            view.shouldCullNonVisibleNodes = true
            //view.preferredFramesPerSecond = 61
            view.presentScene(scene)

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

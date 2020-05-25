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
        gameMenu()
    }
    
    func runGameLevel() {
        gameLevel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameDelegate = self
        gameMenu()
    }
    
    
    func getDeviceSize() {
        // iPhone detection
        let screenWidth = Int(UIScreen.main.bounds.size.width)
        let screenHeight = Int(UIScreen.main.bounds.size.height)
        let screenMax = Int(max(screenWidth,screenHeight))
        let iPhone = screenMax == 568 || screenMax == 667 || screenMax == 736
        let iPhoneX = screenMax == 812 || screenMax == 896
        
        settings.mode = 1 // iPad
        
        if iPhone {
            settings.mode = 2
        } else if iPhoneX {
            settings.mode = 4
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = .red
    }
    
    func setSceneSizeForGame() -> CGSize  {
        //loadGameSettings()
        
        getDeviceSize()
        
        //Put this in a common area
        if (settings.mode == 2 ) {
            //regular iPhone style
            return CGSize(width: 626, height: 352)
            
        } else if (settings.mode == 4) {
            // iPhone X style
            return CGSize(width: 762, height: 352)
            
        } else {
            return CGSize(width: 470, height: 352)
        }
    }
    
    
    func gameMenu() {
        guard
            let view = self.view as? SKView,
            let scene = GameMenu(fileNamed: "GameMenu")
            else { return }
        
        DispatchQueue.main.async  { [weak self] in
            guard let self = self else { return }
            
            scene.scaleMode = .aspectFill
            scene.size = self.setSceneSizeForGame()
            scene.scaleMode = .aspectFill
            scene.backgroundColor = SKColor.init(displayP3Red: 0, green: 20 / 255, blue: 80 / 255, alpha: 1.0)
            view.isMultipleTouchEnabled = true
            view.allowsTransparency = false
            view.isAsynchronous = true
            view.isOpaque = true
            view.clipsToBounds = true
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.shouldCullNonVisibleNodes = true
            view.preferredFramesPerSecond = 61
            view.presentScene(scene)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self else { return }
            self.removeFromParent()
        }
        
    }
    
    func gameLevel() {
        guard
            let view = self.view as? SKView,
            let scene = GameScene(fileNamed: "GameScene")
            else { print("FAILED"); return }
        
        DispatchQueue.main.async  { [weak self] in
            guard let self = self else { return }
            
            scene.scaleMode = .aspectFill
            scene.size = self.setSceneSizeForGame()
            scene.scaleMode = .aspectFill
            scene.backgroundColor = SKColor.black
            view.isMultipleTouchEnabled = true
            view.allowsTransparency = false
            view.isAsynchronous = true
            view.isOpaque = true
            view.clipsToBounds = true
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.shouldCullNonVisibleNodes = true
            view.preferredFramesPerSecond = 61
            view.presentScene(scene)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self else { return }
            self.removeFromParent()
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

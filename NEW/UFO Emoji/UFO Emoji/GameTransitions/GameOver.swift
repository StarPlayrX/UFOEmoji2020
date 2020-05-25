//
//  GameOver.swift
//  UF Emoji
//
//  Created by todd on 12/7/15.
//  Copyright © 2015 Todd Bruss. All rights reserved.
//

import SpriteKit


class GameOver: SKScene {
    
	var gd = gameDelegate
    
    override init(size: CGSize ) {
        
        super.init(size: size)
        
    }
    
    deinit {
        removeAllActions()
        removeAllChildren()
		removeFromParent()
    }
    
    func runner() {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.removeAllActions()
            self.removeAllChildren()
            self.removeFromParent()
            
            self.view?.isMultipleTouchEnabled = true
            self.view?.allowsTransparency = false
            self.view?.isAsynchronous = true
            self.view?.isOpaque = true
            self.view?.clipsToBounds = true
            self.view?.ignoresSiblingOrder = true
            self.view?.showsFPS = true
            self.view?.showsNodeCount = true
            self.view?.shouldCullNonVisibleNodes = true
            self.view?.preferredFramesPerSecond = 61
            
            self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

            let my = GameStartup.gs.loadScores()
            var scorelabel = "🎲"
            
            if my.score == my.hscore {
                scorelabel = "💎"
            }
        
            let message = "🎯 " + scorelabel
            
            self.backgroundColor = SKColor.black
            
            /* Game Over Message */
            let label = SKLabelNode(fontNamed: "Apple Color Emoji")
            label.text = message
            label.fontSize = 68
            label.horizontalAlignmentMode = .center
            label.verticalAlignmentMode = .center
            label.position = CGPoint(x: 0, y: 64 )
            
            /* Show the Score */
            let label2 = SKLabelNode(fontNamed: "Emulogic")
            label2.text = String( my.score )
            label2.fontSize = 34
            label2.horizontalAlignmentMode = .center
            label2.verticalAlignmentMode = .center
            label2.fontColor = SKColor.white
            label2.position = CGPoint(x: 0, y: -64)
            
            self.addChild(label)
            self.addChild(label2)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.gd?.runGameMenu()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [weak self] in
            guard let self = self else { return }

            self.removeAllChildren()
            self.removeAllActions()
            self.removeFromParent()
        }
    
        
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}






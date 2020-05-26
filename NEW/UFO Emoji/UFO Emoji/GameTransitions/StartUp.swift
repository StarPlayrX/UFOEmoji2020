//
//  GameOver.swift
//  UF Emoji
//
//  Created by todd on 12/7/15.
//  Copyright © 2015 Todd Bruss. All rights reserved.
//

import SpriteKit

class StartUp: SKScene {
    
    weak var gd = gameDelegate

    override init(size: CGSize) {
        super.init(size: size)
    }
    
    
    deinit {
        print("StartUp DeInit")

        if hasActions() {
            removeAllActions()
        }
        
        if !children.isEmpty {
            removeAllChildren()
        }
        
        removeFromParent()
    }
    
    func runner() {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
        
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
            
            self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
                        
            self.backgroundColor = SKColor.black
            
            let mainCharacter = heroArray[settings.emoji]
            let goodGuy = levelarray[settings.level]
            let badGuy = antiarray[settings.level]
            
            print(mainCharacter,goodGuy,badGuy,settings.level)
            
            let label1 = SKLabelNode(fontNamed: "Apple Color Emoji")
            label1.fontSize = 72
            label1.text = mainCharacter
            label1.horizontalAlignmentMode = .center
            label1.verticalAlignmentMode = .center
            label1.position = CGPoint(x: self.size.width / 2 - 120, y: self.size.height / 2 )
            self.addChild(label1)
            
            let label2 = SKLabelNode(fontNamed: "Apple Color Emoji")
            label2.fontSize = 72
            label2.text = goodGuy
            label2.xScale = -1
            label2.horizontalAlignmentMode = .center
            label2.verticalAlignmentMode = .center
            label2.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            self.addChild(label2)
            
            let label3 = SKLabelNode(fontNamed: "Apple Color Emoji")
            label3.fontSize = 72
            label3.text = badGuy
            label3.horizontalAlignmentMode = .center
            label3.verticalAlignmentMode = .center
            label3.position = CGPoint(x: self.size.width / 2 + 120, y: self.size.height / 2)
            self.addChild(label3)
            
            
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.gd?.runGameLevel()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

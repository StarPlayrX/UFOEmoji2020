//
//  GameOver.swift
//  UF Emoji
//
//  Created by todd on 12/7/15.
//  Copyright © 2015 Todd Bruss. All rights reserved.
//

import SpriteKit

class StartUp: SKScene {
    
    override init(size: CGSize) {
        
        super.init(size: size)
        backgroundColor = SKColor.black
        
        let mainCharacter = heroArray[settings.emoji]
        let goodGuy = levelarray[settings.level]
        let badGuy = antiarray[settings.level]
        
        let label1 = SKLabelNode(fontNamed: "Apple Color Emoji")
        label1.fontSize = 72
        label1.text = mainCharacter
        label1.horizontalAlignmentMode = .center
        label1.verticalAlignmentMode = .center
        label1.position = CGPoint(x: size.width/2 - 120, y: size.height/2)
        addChild(label1)
        
        let label2 = SKLabelNode(fontNamed: "Apple Color Emoji")
        label2.fontSize = 72
        label2.text = goodGuy
        label2.xScale = -1
        label2.horizontalAlignmentMode = .center
        label2.verticalAlignmentMode = .center
        label2.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label2)
        
        let label3 = SKLabelNode(fontNamed: "Apple Color Emoji")
        label3.fontSize = 72
        label3.text = badGuy
        label3.horizontalAlignmentMode = .center
        label3.verticalAlignmentMode = .center
        label3.position = CGPoint(x: size.width/2 + 120, y: size.height/2)
        addChild(label3)
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.0),
            SKAction.run() {
                levelLauncher(self:self)
            }
            ]))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//Loads the Startup Scenex
func startUp(_ scene:SKScene) {
    scene.run(SKAction.sequence([
        SKAction.wait(forDuration: 0.0),
        SKAction.run() {
            let transition = SKTransition.doorsOpenHorizontal(withDuration: 2.0)
            let gameOverScene = StartUp( size: scene.size )
            setSceneSizeForMenu(scene: scene)
            gameOverScene.scaleMode = .aspectFill
            scene.view?.presentScene(gameOverScene, transition: transition)
        }
        ]))
}

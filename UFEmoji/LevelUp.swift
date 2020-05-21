//
//  LevelUp.swift
//  UF Emoji
//
//  Created by todd on 12/7/15.
//  Copyright © 2015 Todd Bruss. All rights reserved.
//

import SpriteKit

class LevelUp: SKScene {
    
    override init(size: CGSize ) {
        
        super.init(size: size)
        
        let lives = GameStartup().loadScores().lives
        
        let heroMessage = levelarray[settings.level]
        
        let enemyMessage = antiarray[settings.level]

        let livesMessage = livesDisplay[ lives ]
        
        backgroundColor = SKColor.black
        
        let label = SKLabelNode(fontNamed: "Apple Color Emoji")
        label.text = heroMessage
        label.fontSize = 72
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.xScale = -1
        label.position = CGPoint(x: size.width/2 - 48, y: size.height/2 + 72)
        addChild(label)
        
        let label3 = SKLabelNode(fontNamed: "Apple Color Emoji")
        label3.text = enemyMessage
        label3.fontSize = 72
        label3.horizontalAlignmentMode = .center
        label3.verticalAlignmentMode = .center
        label3.position = CGPoint(x: size.width/2 + 48, y: size.height/2 + 72)
        addChild(label3)
        
    
        let label2 = SKLabelNode(fontNamed: "Apple Color Emoji")
        label2.text = livesMessage
        label2.fontSize = 64
        label2.horizontalAlignmentMode = .center
        label2.verticalAlignmentMode = .center
        label2.position = CGPoint(x: size.width/2, y: size.height/2 - 72)
        addChild(label2)
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.0),
            SKAction.run() {
                levelLauncher(self: self)
            }
            ]))
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Loads the LevelUp Scene
func starPlayrOneLevelUpX(world:SKNode?, moving:SKNode?, scene:SKScene?, hero: SKSpriteNode?, tractor: SKSpriteNode?) {
    
    guard let world = world,
          let moving = moving,
          let hero = hero,
          var scene = scene,
          let tractor = tractor
        else { return }
    hero.removeFromParent()
    tractor.removeFromParent()
    moving.speed = moving.speed / 2
    world.speed =  world.speed / 2
    
    scene.run(SKAction.sequence([
        SKAction.wait(forDuration: 1.0),
        SKAction.run() {
            let reveal = SKTransition.fade(withDuration: TimeInterval(1.0))
            let gameOverScene = LevelUp( size: scene.size )
            setSceneSizeForGame(scene: scene)
            gameOverScene.scaleMode = .aspectFill
            scene.view?.presentScene(gameOverScene, transition: reveal)
        }
        ]))
    
}


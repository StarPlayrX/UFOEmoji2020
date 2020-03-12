//
//  GameOver.swift
//  UF Emoji
//
//  Created by todd on 12/7/15.
//  Copyright © 2015 Todd Bruss. All rights reserved.
//

import SpriteKit

class GameOver: SKScene {
    
    override init(size: CGSize ) {
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let movie = SKVideoNode(fileNamed: "sadmonkey1.mp4")
        movie.size = CGSize(width: 128, height: 128)
        movie.position = CGPoint(x: 0,
                                 y: 64)
        movie.alpha = 1.0
        movie.play()
        
        
        let score = GameStartup().loadScores().score
        let hscore = GameStartup().loadScores().hscore
        var scorelabel = "🎲"
        
        if score == hscore {
            scorelabel = "💎"
        }
        
        
        
        
        let message = "🎯    " + scorelabel
        
        backgroundColor = SKColor.black
        
        
        
        /* Game Over Message */
        let label = SKLabelNode(fontNamed: "Apple Color Emoji")
        label.text = message
        label.fontSize = 68
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: 64 )
        
        
        /* Show the Score */
        let label2 = SKLabelNode(fontNamed: "Emulogic")
        label2.text = String( score )
        label2.fontSize = 34
        label2.horizontalAlignmentMode = .center
        label2.verticalAlignmentMode = .center
        label2.fontColor = SKColor.white
        label2.position = CGPoint(x: 0, y: -64)
        
        movie.alpha = 0
        label.alpha = 0
        label2.alpha = 0
        
        addChild(movie)
        addChild(label)
        addChild(label2)
        run(SKAction.sequence([
            SKAction.run() {
                movie.run(SKAction.fadeAlpha(to: 1.0, duration: 1.3))
                label.run(SKAction.fadeAlpha(to: 1.0, duration: 1.3))
                label2.run(SKAction.fadeAlpha(to: 1.0, duration: 1.3))


            }
            
            ]))
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 6.0),
            SKAction.run() {
                let transition = SKTransition.fade(with: UIColor.black, duration: 3.0)
                if let scene = GameScene(fileNamed: "GameMenu"){
                    
                    let skView = self.view! as SKView
                    
                    setSceneSizeForMenu(scene: scene)
                    
                    skView.showsFPS = false
                    skView.showsNodeCount = false
                    skView.showsPhysics = false
                    skView.isAsynchronous = true
                    skView.ignoresSiblingOrder = true
                    skView.clipsToBounds = false
                    scene.scaleMode = .aspectFill
                    setSceneSizeForMenu(scene: scene)
                    scene.backgroundColor = SKColor.black
                    
                    scene.scaleMode = .aspectFill
                    
                    skView.presentScene(scene, transition:transition)
                }
            }
            ]))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//Loads the game over scene
func gameOver(world:SKNode, moving:SKNode, scene:SKScene, hero: SKSpriteNode, tractor: SKSpriteNode) {
    
    let explosion = SKEmitterNode(fileNamed: "fireParticle.sks")!
    explosion.alpha = 0.5
    explosion.position = hero.position
    scene.addChild(explosion)
    tractor.removeFromParent()
    hero.physicsBody?.affectedByGravity = true;
    moving.speed = moving.speed / 2
    world.speed =  world.speed / 2
    
    scene.run(SKAction.sequence([
        SKAction.wait(forDuration: 3.0),
        SKAction.run() {
            let reveal = SKTransition.fade(withDuration: TimeInterval(1.5))
            let gameOverScene = GameOver( size: scene.size )
            setSceneSizeForMenu(scene: scene)
            gameOverScene.scaleMode = .aspectFill
            scene.view?.presentScene(gameOverScene, transition: reveal)
        }
        ]))
}







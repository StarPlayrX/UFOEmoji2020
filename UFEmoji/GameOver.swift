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
        
    }
    
    func runner() {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        /*let movie = SKVideoNode(fileNamed: "sadmonkey1.mp4")
        movie.size = CGSize(width: 128, height: 128)
        movie.position = CGPoint(x: 0,
                                 y: 64)
        movie.alpha = 1.0
        movie.play()*/
        
        
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
        
        label.alpha = 0
        label2.alpha = 0
        
        scene?.removeAllActions()
        scene?.removeAllChildren()
        scene?.removeFromParent()
        
        scene?.addChild(label)
        scene?.addChild(label2)
   
        run(SKAction.sequence([
            SKAction.run() {
                label.run(SKAction.fadeAlpha(to: 1.0, duration: 1.3))
                label2.run(SKAction.fadeAlpha(to: 1.0, duration: 1.3))
            },
            
            SKAction.wait(forDuration: 3.0),
            SKAction.run() { [ weak self] in
                
                self?.scene?.removeAllActions()
                self?.scene?.removeAllChildren()
                self?.scene?.removeFromParent()
                
            },
            
            SKAction.run() { [ weak self] in
                guard let self = self else { return }
                levelLauncherXX(self:self, filename: "GameMenu")
            }
        ]))
        
        /*run(SKAction.sequence([
            
            SKAction.run() { [weak self] in
                guard let self = self else { return }
                levelLauncherXX(self:self, filename: "GameMenu")
            }
            
        ]))*/
        
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}






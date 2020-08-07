//
//  GameParallax.swift
//  UFO Emoji
//
//  Created by Todd Bruss on 5/28/20.
//  Copyright © 2020 Todd Bruss. All rights reserved.
//

import SpriteKit


class GameParallax : SKNode {
    
    private weak var parallax: SKReferenceNode!
    private var bounds: CGRect!
    
    init (parallax: SKReferenceNode, bounds: CGRect) {
        super.init()
        self.parallax = parallax
        self.bounds = bounds

    }
    
    deinit {
        print("Back Parallax Deinit!")
        parallax = nil
        bounds = nil
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setParallax(texture: SKTexture?) -> SKReferenceNode {
        guard let t = texture else { return SKReferenceNode() }
        t.filteringMode = .nearest
        t.preload { [weak self] in
            guard
                let self = self
                else { return }
            
            let factor = CGFloat(2.0) //PDF Textures are 50% scaled up 200% to save memory while retaining a decent look
            let width = t.size().width * factor
            let interations = Int(round( self.bounds.width / width / factor ))
            var sprite = SKSpriteNode(texture: t)
            sprite.name = String("parallaxSprite")
            sprite.xScale = factor
            sprite.yScale = factor
            
            //Place from Center
            for i in -interations...interations  {
                sprite.position = CGPoint(x: CGFloat(i) * width, y: 0)
                self.parallax.addChild(sprite.copy() as! SKSpriteNode )
            }
            
            self.parallax.zPosition = -243
            sprite = SKSpriteNode()
            
            self.parallax.name = "parallax"
        }
        
        return parallax
    }
}

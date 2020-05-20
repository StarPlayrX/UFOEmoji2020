//
//  GameStartup.swift
//  UF Emoji
//
//  Created by todd on 12/3/15.
//  Copyright © 2015 Todd Bruss. All rights reserved.
//

import SpriteKit

//var mynode = SKReferenceNode()

class GameStartup: GameScene {
    
    func readyPlayerOne (_ scene:SKScene) -> (bombsbutton:SKSpriteNode?,firebutton:SKSpriteNode?,hero:SKSpriteNode?,canape:SKSpriteNode?,tractor:SKSpriteNode?,bombsbutton2:SKSpriteNode?,firebutton2:SKSpriteNode?) {
        
        var rocket = "aliensaucer"
        var glass = "aliencanape"
        var offset = 0;
        var size = 24;
        
        //alien
        if settings.emoji == 1 {
            rocket = "aliensaucer"
            glass = "aliencanape"
            offset = 10
            size = 26;
            //monkey
        } else if settings.emoji == 2 {
            rocket = "monkeyrocket"
            glass = "monkeycanape"
            offset = 0
            size = 32
            //poop emoji
        }  else if settings.emoji == 3 {
            rocket = "poopship"
            glass = "poopcanape"
            offset = 0
            size = 36
        }
        
        //drawsprites
        hero = defineSprite (
            texture: rocket,
            scene: scene,
            name: "hero",
            category: heroCategory,
            collision: wallCategory,
            contact: worldCategory + levelupCategory,
            field: 1,
            dynamic: true,
            allowRotation: false,
            affectedGravity: false,
            zPosition: 150,
            alpha: 1.0,
            speed: 1,
            alphaThreshold: 0.0
        ).drawSprite()
        
        heroEmoji = SKLabelNode(fontNamed:"Apple Color Emoji")
        heroEmoji.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        heroEmoji.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        heroEmoji.alpha = 1.0
        heroEmoji.position = CGPoint(x: 0, y: offset)
        heroEmoji.fontSize = CGFloat(size)
        heroEmoji.zPosition = 24
        heroEmoji.text = heroArray[settings.emoji]
        hero.addChild(heroEmoji)
        
        canape = defineSprite (
            texture: glass,
            scene: scene,
            name: "canape",
            category: heroCategory,
            collision: wallCategory,
            contact: worldCategory,
            field: 1,
            dynamic: true,
            allowRotation: false,
            affectedGravity: false,
            zPosition: 160,
            alpha: 0.5,
            speed: 1,
            alphaThreshold: 0.0
        ).drawSprite()
        
        
        
        tractor = defineSprite (
            texture: "tractorbeam",
            scene: scene,
            name: "tractorbeam",
            category: tractorCategory,
            collision: 0,
            contact: itemCategory + fishCategory,
            field: 1,
            dynamic: true,
            allowRotation: false,
            affectedGravity: false,
            zPosition: 140,
            alpha: 0.1,
            speed: 1,
            alphaThreshold: 0.0
        ).drawSprite()
        
        hud = defineSprite (
            texture: "hud45-right",
            scene: scene,
            name: "hud-right",
            category: 0,
            collision: 0,
            contact: 0,
            field: 0,
            dynamic: false,
            allowRotation: false,
            affectedGravity: false,
            zPosition: 11,
            alpha: 1.0,
            speed: 0,
            alphaThreshold: 0
        ).drawHud()
        
        hud = defineSprite (
            texture: "hud45-left",
            scene: scene,
            name: "hud-left",
            category: 0,
            collision: 0,
            contact: 0,
            field: 0,
            dynamic: false,
            allowRotation: false,
            affectedGravity: false,
            zPosition: 11,
            alpha: 1.0,
            speed: 0,
            alphaThreshold: 0
        ).drawHud()
        
        hud = defineSprite (
            texture: "hud45-btm",
            scene: scene,
            name: "hud-down",
            category: 0,
            collision: 0,
            contact: 0,
            field: 0,
            dynamic: false,
            allowRotation: false,
            affectedGravity: false,
            zPosition: 11,
            alpha: 1.0,
            speed: 0,
            alphaThreshold: 0
        ).drawHud()
        
        hud = defineSprite (
            texture: "hud45-top",
            scene: scene,
            name: "hud-top",
            category: 0,
            collision: 0,
            contact: 0,
            field: 0,
            dynamic: false,
            allowRotation: false,
            affectedGravity: false,
            zPosition: 11,
            alpha: 1.0,
            speed: 0,
            alphaThreshold: 0
        ).drawHud()
        
        firebutton = defineSprite (
            texture: "fire45-right",
            scene: scene,
            name: "fire-right",
            category: 0,
            collision: 0,
            contact: 0,
            field: 0,
            dynamic: false,
            allowRotation: false,
            affectedGravity: false,
            zPosition: 10,
            alpha: 0.0001,
            speed: 0,
            alphaThreshold: 0
        ).drawHud()
        
        firebutton2 = defineSprite (
            texture: "fire45-left",
            scene: scene,
            name: "fire-left",
            category: 0,
            collision: 0,
            contact: 0,
            field: 0,
            dynamic: false,
            allowRotation: false,
            affectedGravity: false,
            zPosition: 10,
            alpha: 0.0001,
            speed: 0,
            alphaThreshold: 0
        ).drawHud()
        
        bombsbutton2 = defineSprite (
            texture: "fire45-top",
            scene: scene,
            name: "fire-top",
            category: 0,
            collision: 0,
            contact: 0,
            field: 0,
            dynamic: false,
            allowRotation: false,
            affectedGravity: false,
            zPosition: 10,
            alpha: 0.0001,
            speed: 0,
            alphaThreshold: 0
        ).drawHud()
        
        bombsbutton = defineSprite (
            texture: "fire45-btm",
            scene: scene,
            name: "fire-down",
            category: 0,
            collision: 0,
            contact: 0,
            field: 0,
            dynamic: false,
            allowRotation: false,
            affectedGravity: false,
            zPosition: 10,
            alpha: 0.0001,
            speed: 0,
            alphaThreshold: 0
        ).drawHud()
        
        createCanapeJoint(scene)
        createHeroJoint(scene)
        arcadeJoyPad(scene)
        
        return (bombsbutton,firebutton,hero,canape,tractor,bombsbutton2,firebutton2)
    }
    
    //MARK: Sprites
    struct defineSprite {
        let texture: String
        let scene: SKScene
        let name: String
        let category:UInt32
        let collision:UInt32
        let contact:UInt32
        let field:UInt32
        let dynamic:Bool
        let allowRotation:Bool
        let affectedGravity:Bool
        let zPosition:CGFloat
        let alpha:CGFloat
        let speed:CGFloat
        let alphaThreshold: Float
        
        func drawSprite() -> SKSpriteNode  {
            let sprite = SKSpriteNode(imageNamed: texture)
            
            if name == "canape" {
                let radius = sprite.size.width / 2 - 12
                sprite.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(radius))
                sprite.physicsBody?.restitution = 0
                sprite.position = CGPoint(x:sprite.position.x, y: sprite.position.y + 30)
            } else if name == "hero" {
                let radius = sprite.size.width / 4 - 6
                sprite.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(radius))
                sprite.physicsBody?.restitution = 0
                sprite.position = CGPoint(x:sprite.position.x, y: sprite.position.y + 30)
            } else if name == "tractorbeam" {
                let radius = sprite.size
                sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: radius.width + 5, height: radius.height + 5))
                sprite.physicsBody?.restitution = 0
                sprite.position = CGPoint(x:sprite.position.x, y: sprite.position.y - 15)
                
            } else {
                sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, alphaThreshold: alphaThreshold, size: sprite.size)
                
            }
            
            sprite.physicsBody?.categoryBitMask = category
            sprite.physicsBody?.collisionBitMask = collision
            sprite.physicsBody?.contactTestBitMask = contact
            sprite.physicsBody?.fieldBitMask = field
            sprite.physicsBody?.isDynamic = dynamic
            sprite.physicsBody?.allowsRotation = allowRotation
            sprite.physicsBody?.affectedByGravity = affectedGravity
            sprite.physicsBody?.velocity = CGVector( dx: 0, dy: 0 )
            sprite.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 0.0))
            sprite.name = name
            
            sprite.zPosition = zPosition
            sprite.alpha = alpha
            sprite.speed = speed
            sprite.zRotation = 0.0
            sprite.isUserInteractionEnabled = false
            scene.addChild(sprite)
            sprite.texture?.preload {
            }
            
            return sprite
        }
        
        func drawHud() -> SKSpriteNode  {
            
            let sprite = SKSpriteNode(imageNamed: texture)
            let btnLoc = settings.stick ? "R" : "L"
            sprite.position = CGPoint(x:0,y:0)
            
            if name == "fire-right" ||  name == "hud-right" {
                sprite.position.x = sprite.size.width / 2
                sprite.position.y = -sprite.size.height / 2
            }
            
            if name == "fire-left" || name == "hud-left" {
                sprite.position.x = -sprite.size.width / 2
                sprite.position.y = sprite.size.height / 2
            }
            
            if name == "fire-top" || name == "hud-top" {
                sprite.position.x = sprite.size.width / 2
                sprite.position.y = sprite.size.height / 2
            }
            
            if name == "fire-down" ||  name == "hud-down" {
                sprite.position.x = -sprite.size.width / 2
                sprite.position.y = -sprite.size.height / 2
            }
            
            sprite.zPosition = 1000
            sprite.alpha = alpha
            sprite.name = name
            if name == "hud-right" ||  name == "hud-down" || name == "hud-top" || name == "hud-left" {
                sprite.isUserInteractionEnabled = true
            } else {
                sprite.isUserInteractionEnabled = false
            }
            
            //let node = SKReferenceNode()
            //node.name = name
            //scene.camera?.addChild(node)
            headsUpDisplay.addChild(sprite)
            //node.zRotation = CGFloat(Double.pi/4)
            
            var xAdjust = CGFloat(1.0)
            var yAdjust = CGFloat(1.0)
            //iPhone (convert this to an enum)
            if settings.mode == 4 {
                xAdjust = CGFloat(1.4)
                yAdjust = CGFloat(1.1)
            }
            
            /* move the button to where we want them */
            if btnLoc == "L" {
                headsUpDisplay.position = CGPoint(
                    x: CGFloat(scene.frame.size.width / -2 + (85 * xAdjust) ) ,
                    y: CGFloat(scene.frame.size.height / -2 + (85 * yAdjust ) )
                )
            } else {
                headsUpDisplay.position = CGPoint(
                    x: CGFloat(scene.frame.size.width / 2 - (85 * xAdjust)  ) ,
                    y: CGFloat(scene.frame.size.height / -2 + (85 * yAdjust ) )
                )
            }
            
            if settings.mode == 1 {
                
                if btnLoc == "L" {
                    headsUpDisplay.position = CGPoint(x: CGFloat(scene.frame.size.width / -2 + (87 * 0.75) ) ,y:  CGFloat(scene.frame.size.height / -2 + (87 * 0.75)) )
                } else {
                    headsUpDisplay.position = CGPoint(x: CGFloat(scene.frame.size.width / 2 - (87 * 0.75) ) ,y:  CGFloat(scene.frame.size.height / -2 + (87 * 0.75)) )
                }
                
                headsUpDisplay.setScale(0.75)
                
            }
            
            
            return sprite
        }
    }
    
    
    
    func createHeroJoint(_ scene:SKScene) {
        let bodyA = hero.physicsBody!
        let bodyB = tractor.physicsBody!
        bodyA.density = 1.0
        let joint = SKPhysicsJointPin.joint(withBodyA: bodyA,  bodyB:bodyB, anchor: hero.position)
        scene.physicsWorld.add(joint)
    }
    
    func createCanapeJoint(_ scene:SKScene) {
        let bodyA = hero.physicsBody!
        let bodyB = canape.physicsBody!
        let joint = SKPhysicsJointPin.joint(withBodyA: bodyA,  bodyB:bodyB, anchor: hero.position)
        joint.rotationSpeed = 1.0
        scene.physicsWorld.add(joint)
    }
    
    func arcadeJoyPad(_ scene:SKScene) {
        let stick = settings.stick ? "L" : "R"
        
        var xAdjust = CGFloat(1.0)
        var yAdjust = CGFloat(1.0)
        //iPhone (convert this to an enum)
        if settings.mode == 4 {
            xAdjust = CGFloat(1.4)
            yAdjust = CGFloat(1.1)
        }
        
        /* move the stick to where we want it */
        if stick == "L" {
            ThumbPad.position = CGPoint(
                x: CGFloat(scene.frame.size.width / -2 + (85 * xAdjust) ) ,
                y: CGFloat(scene.frame.size.height / -2 + (85 * yAdjust ) )
            )
        } else {
            ThumbPad.position = CGPoint(
                x: CGFloat(scene.frame.size.width / 2 - (85 * xAdjust)  ) ,
                y: CGFloat(scene.frame.size.height / -2 + (85 * yAdjust ) )
            )
        }
        
        ThumbPad.delagate = self
        scene.camera?.addChild(ThumbPad)
        ThumbPad.zPosition = 1000
        ThumbPad.name = "ArcadeJoyPad"
        
        if settings.mode == 1 {
            ThumbPad.setScale(0.75)
            
            if stick == "L" {
                ThumbPad.position = CGPoint(x: CGFloat(scene.frame.size.width / -2 + (87 * 0.75) ) ,y:  CGFloat(scene.frame.size.height / -2 + (87 * 0.75)) )
            } else {
                ThumbPad.position = CGPoint(x: CGFloat(scene.frame.size.width / 2 - (87 * 0.75) ) ,y:  CGFloat(scene.frame.size.height / -2 + (87 * 0.75)) )
            }
        }
        
    }
    
    func loadScores() -> (level: Int, highlevel: Int, score: Int, hscore: Int, lives: Int) {
        let hscore = settings.highscore;
        let highlevel = settings.highlevel;
        let score = settings.score;
        let level = settings.level;
        let lives = settings.lives;
        return (level, highlevel, score, hscore, lives)
    }
    
    func saveScores(level: Int, highlevel: Int, score: Int, hscore: Int, lives: Int) {
        settings.highlevel = highlevel;
        settings.score = score;
        settings.level = level;
        settings.highscore = hscore;
        settings.lives = lives;
        saveGameSettings()
    }
}

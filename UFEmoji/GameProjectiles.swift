//
//  GameProjectiles.swift
//  UF Emoji
//
//  Created by Todd Bruss on 12/6/15.
//  Copyright © 2015 Todd Bruss. All rights reserved.
//

import SpriteKit


class GameProjectiles {

    var alternator = true
    var spinner = CGFloat(1)

    var laser: SKSpriteNode!
    var bomb: SKSpriteNode!
    
    let bombPhysicsBody =  SKPhysicsBody(circleOfRadius: 16);
    let bombEmoji: SKLabelNode! = SKLabelNode(fontNamed:"Apple Color Emoji")
    var 💩 = "💩"
    var fireSound = "fire.m4a";
    var bombSound = "wah2.m4a"
    
    init(laserbeak laserbeam:UInt32, scene:SKScene, hero: (position:CGPoint, zRotation: CGFloat, velocity: CGVector), reverse: Bool ) {
        
        //if !hero.isHidden {
        
        if !supermanLaser {
            laser = SKSpriteNode(texture: SKTexture(imageNamed: "laserbeam") )
        } else {
            laser = SKSpriteNode(texture: SKTexture(imageNamed: "superlaserbeam") )
        }
        
        //var laserPhysicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "laserbeam"), alphaThreshold: 0.9, size: SKSpriteNode(texture: SKTexture(imageNamed: "laserbeam")).size)
        var laserPhysicsBody = SKPhysicsBody(rectangleOf: laser.size)
        
        alternator = !alternator
        
        //Monkey
        if settings.emoji == 2 {
            
            laser.physicsBody?.applyAngularImpulse(5)
            if alternator {
                spinner = 1
            } else {
                spinner = -1
            }
            
            //let texture = SKTexture.init(image: self.transparentimage)
            laser = SKSpriteNode()
            laserPhysicsBody =  SKPhysicsBody(circleOfRadius: 16);
            let laserEmoji: SKLabelNode! = SKLabelNode(fontNamed:"Apple Color Emoji")
            let 🍌 = "🍌"
            
            laserEmoji.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            laserEmoji.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            //laserEmoji.alpha = 1.0
            //laserEmoji.position = CGPoint(x: 0, y: 0)
            laserEmoji.text = String(🍌)
            laserEmoji.fontSize = 32
            laser.addChild(laserEmoji)
        }
        
        if !supermanLaser {
            laser.name = "🚩"
        } else {
            laser.name = "💠"
        }
        
        laser.isUserInteractionEnabled = false
        laser.physicsBody = laserPhysicsBody
        laser.zPosition = -100
        laser.physicsBody?.isDynamic = true
        laser.physicsBody?.affectedByGravity = false
        laser.physicsBody?.mass = 0
        laser.physicsBody?.fieldBitMask = 0
        laser.physicsBody?.categoryBitMask = 64
        laser.physicsBody?.collisionBitMask = 0
        //let ctb = UInt32(2 + 8 + 16 + 256 + 512 + 1024 + 4096 + 8192)
        let ctb = UInt32(14106)
        laser.physicsBody?.contactTestBitMask = UInt32(ctb)
        laser.physicsBody?.applyImpulse(CGVector(dx: 100,dy: 0))
        laser.speed = CGFloat(0.8)
        laser.physicsBody?.usesPreciseCollisionDetection = false
        let heroPositionX = hero.position.x
        
        if doublelaser == 1 && settings.emoji != 2 {
            laser.position = (CGPoint(x:heroPositionX, y:hero.position.y - 5))
        } else if doublelaser == 1 && settings.emoji == 2 {
            laser.position = (CGPoint(x:heroPositionX, y:hero.position.y - 16))
        } else {
            laser.position = hero.position
        }
        
        let rotateLaser = hero.zRotation * -3
        
        let constantX = CGFloat(750)
        let constantY = CGFloat(250)
        let uno = CGFloat(1)
        
        let d = reverse ? (x : -uno, y : uno) : (x : uno, y : -uno)
        
        laser.physicsBody?.velocity = CGVector( dx: d.x * constantX + hero.velocity.dx, dy: rotateLaser * d.y * constantY )
        
        laser.zRotation = hero.zRotation
        scene.addChild(laser)
        
        if settings.emoji == 2 {
            let decay = SKAction.wait(forDuration: TimeInterval(0.6 * Double(settings.mode)))
            let spin = SKAction.rotate(byAngle: CGFloat.pi * 3.0 * spinner, duration: 2)
            let remove = SKAction.removeFromParent()
            laser.run(SKAction.sequence([spin,decay,remove]))
            
        } else {
            let decay = SKAction.wait(forDuration: TimeInterval(0.6 * Double(settings.mode)))
            let remove = SKAction.removeFromParent()
            laser.run(SKAction.sequence([decay,remove]))
        }
        
        ///Power Up that lasts the entire level!
        if doublelaser == 1 {
            let laser2 = laser.copy()
            (laser2 as! SKSpriteNode).position = (CGPoint(x:heroPositionX, y:hero.position.y + 5))
            scene.addChild(laser2 as! SKSpriteNode)
        }
        
        if doublelaser >= 2 {
            if !reverse {
                let laser3 = laser.copy()
                (laser3 as! SKSpriteNode).position = (CGPoint(x:heroPositionX - 10, y:hero.position.y + 10))
                scene.addChild(laser3 as! SKSpriteNode)
                
                let laser4 = laser.copy()
                (laser4 as! SKSpriteNode).position = (CGPoint(x:heroPositionX - 10, y:hero.position.y - 10))
                scene.addChild(laser4 as! SKSpriteNode)
            } else {
                let laser3 = laser.copy()
                (laser3 as! SKSpriteNode).position = (CGPoint(x:heroPositionX + 10, y:hero.position.y + 10))
                scene.addChild(laser3 as! SKSpriteNode)
                
                let laser4 = laser.copy()
                (laser4 as! SKSpriteNode).position = (CGPoint(x:heroPositionX + 10, y:hero.position.y - 10))
                scene.addChild(laser4 as! SKSpriteNode)
            }
        }
        
        if doublelaser >= 3 {
            if !reverse {
                let laser5 = laser.copy()
                (laser5 as! SKSpriteNode).position = (CGPoint(x:heroPositionX - 20, y:hero.position.y + 15))
                scene.addChild(laser5 as! SKSpriteNode)
                
                let laser6 = laser.copy()
                (laser6 as! SKSpriteNode).position = (CGPoint(x:heroPositionX - 20, y:hero.position.y - 15))
                scene.addChild(laser6 as! SKSpriteNode)
            } else {
                let laser5 = laser.copy()
                (laser5 as! SKSpriteNode).position = (CGPoint(x:heroPositionX + 20, y:hero.position.y + 15))
                scene.addChild(laser5 as! SKSpriteNode)
                
                let laser6 = laser.copy()
                (laser6 as! SKSpriteNode).position = (CGPoint(x:heroPositionX + 20, y:hero.position.y - 15))
                scene.addChild(laser6 as! SKSpriteNode)
            }
            
        }
        
        
        if settings.sound {
            let fire: SKAction = SKAction.playSoundFileNamed(fireSound, waitForCompletion: false)
            laser.run(fire)
            
        }
    }
    
    
    
    init(bombsaway laserbeam:UInt32, scene:SKScene, hero: (position:CGPoint, zRotation: CGFloat, velocity: CGVector), reverse: Bool ) {
        alternator = !alternator
        
        bomb = SKSpriteNode()
        bomb.position = (CGPoint(x:hero.position.x, y:hero.position.y - 10))
        bomb.name = "💣"
        
        if !trident {
            bomb.name = "💣"
        } else {
            bomb.name = "🔱" 
        }
        
        bomb.isUserInteractionEnabled = false
        bomb.physicsBody = bombPhysicsBody
        bomb.physicsBody?.affectedByGravity = true
        bomb.physicsBody?.isDynamic = true
        bomb.physicsBody?.affectedByGravity = true
        bomb.physicsBody?.allowsRotation = true
        bomb.physicsBody?.categoryBitMask = 64
        bomb.physicsBody?.collisionBitMask = 4
        //let ctb = UInt32(2 + 8 + 16 + 256 + 512 + 1024 + 8192)
        let ctb = UInt32(14106)
        bomb.physicsBody?.contactTestBitMask = ctb
        bomb.physicsBody?.applyImpulse(CGVector(dx: 0,dy: 50))
        bomb.physicsBody?.density = 0
        bomb.physicsBody?.fieldBitMask = 0
        bomb.physicsBody?.applyAngularImpulse(20)
        bomb.physicsBody?.restitution = 0.5
        
        var wait = 400
        
        if reverse {
            bomb.physicsBody?.velocity =  CGVector( dx: hero.velocity.dx * 1.15, dy: 500)
            wait = 800
            
            
        } else {
            bomb.physicsBody?.velocity =  CGVector( dx: hero.velocity.dx , dy: -350 )
        }
        
        
        if ( alternator ) {
            bomb.zPosition = 100
        } else {
            bomb.zPosition = -100;
        }
        
        
        bombEmoji.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        bombEmoji.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        //bombEmoji.position = CGPoint(x: 0, y: 0)
        
        
        if !trident {
            bombEmoji.text = String("💩") //bombsaway
        } else {
            bombEmoji.text = String("🔱") //bombsaway
        }
        
        if trident && !reverse {
            bombEmoji.yScale = -1
        }
        bombEmoji.fontSize = 32
        bomb.addChild(bombEmoji)
        bomb.speed = 200
        scene.addChild(bomb)
        
        let decay = SKAction.wait(forDuration: TimeInterval(wait))
        let remove = SKAction.removeFromParent()
        bomb.run(SKAction.sequence([decay,remove]))
        
        if settings.sound {
            let bombs: SKAction = SKAction.playSoundFileNamed(bombSound, waitForCompletion: false)
            bomb.run(bombs)
        }
    }
    
    func firebomb(firebomb:SKSpriteNode) {
        let fadeIn = SKAction.fadeAlpha(to: 0.5, duration:TimeInterval(0.3))
        let myDecay = SKAction.wait(forDuration: 0.5)
        let fadeOut = SKAction.fadeAlpha(to: 0.0001, duration:TimeInterval(0.6))
        firebomb.run(SKAction.sequence([fadeIn,myDecay,fadeOut]))
    }
    
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage
    {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width, height: size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}

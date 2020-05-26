//
//  GameProjectiles.swift
//  UF Emoji
//
//  Created by Todd Bruss on 12/6/15.
//  Copyright © 2015 Todd Bruss. All rights reserved.
//

import SpriteKit


class GameProjectiles {
    
    var 🛥 = true
    var 🍕 = CGFloat(1)
    
    var 👁: SKSpriteNode!
    var 💣: SKSpriteNode!
    
    let 🦞 = SKPhysicsBody(circleOfRadius: 16);
    let 🧨: SKLabelNode! = SKLabelNode(fontNamed:"Apple Color Emoji")
    var 💩 = "💩"
    var 🚨 = "fire.m4a"
    var 💥 = "wah2.m4a"

    var 🌞 = UInt32(0)
    var 🚞 = SKScene()
    let 🍺 = CGFloat(16)
    let 🍎 = "Apple Color Emoji"
    let 🍌 = "🍌"
	let 🦸 = "laserbeam"
    let 🥾 = "super"
   
    func bullets (superhero: (position:CGPoint, zRotation: CGFloat, velocity: CGVector), reverse: Bool) {
    
        let 🧵 = 🔋 ?  🥾 + 🦸 : 🦸
                
        👁 = SKSpriteNode(texture: SKTexture(imageNamed: 🧵 ))
    
        
        var 👨‍🔬 = SKPhysicsBody(rectangleOf: 👁.size)
        
        🛥 = !🛥
        
        //Monkey
        if settings.emoji == 2 {
            
            👁.physicsBody?.applyAngularImpulse(5)
            if 🛥 {
                🍕 = 1
            } else {
                🍕 = -1
            }
            
           
            //let texture = SKTexture.init(image: self.transparentimage)
            👁 = SKSpriteNode()
            👨‍🔬 = SKPhysicsBody(circleOfRadius: 🍺);
            let 🔫: SKLabelNode = SKLabelNode(fontNamed:🍎)
            
            🔫.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            🔫.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            🔫.text = 🍌
            🔫.fontSize = 32
            👁.addChild(🔫)
        }
        
        
        if !🔋 {
            👁.name = "🚩"
        } else {
            👁.name = "💠"
        }
        
        👁.isUserInteractionEnabled = false
        👁.physicsBody = 👨‍🔬
        👁.zPosition = -100
        👁.physicsBody?.isDynamic = true
        👁.physicsBody?.affectedByGravity = false
        👁.physicsBody?.mass = 0
        👁.physicsBody?.fieldBitMask = 0
        👁.physicsBody?.categoryBitMask = 64
        👁.physicsBody?.collisionBitMask = 0
        let ctb = UInt32(14106)
        👁.physicsBody?.contactTestBitMask = UInt32(ctb)
        👁.physicsBody?.applyImpulse(CGVector(dx: 100,dy: 0))
        👁.speed = CGFloat(0.8)
        👁.physicsBody?.usesPreciseCollisionDetection = false
        let superheroPositionX = superhero.position.x
        
        if doublelaser == 1 && settings.emoji != 2 {
            👁.position = (CGPoint(x:superheroPositionX, y:superhero.position.y - 5))
        } else if doublelaser == 1 && settings.emoji == 2 {
            👁.position = (CGPoint(x:superheroPositionX, y:superhero.position.y - 16))
        } else {
            👁.position = superhero.position
        }
        
        let rotateLaser = superhero.zRotation * -3
        
        let constantX = CGFloat(750)
        let constantY = CGFloat(250)
        let uno = CGFloat(1)
        
        let d = reverse ? (x : -uno, y : uno) : (x : uno, y : -uno)
        
        👁.physicsBody?.velocity = CGVector( dx: d.x * constantX + superhero.velocity.dx, dy: rotateLaser * d.y * constantY )
        
        👁.zRotation = superhero.zRotation
        
        if 👁.name!.isEmpty {
            print(👁 as Any)
        }
        
        let laserDupe = 👁.copy() as! SKSpriteNode
        🚞.addChild(laserDupe)
        
        if settings.emoji == 2 {
            let decay = SKAction.wait(forDuration: TimeInterval(0.6 * Double(settings.mode)))
            let spin = SKAction.rotate(byAngle: CGFloat.pi * 3.0 * 🍕, duration: 2)
            let remove = SKAction.removeFromParent()
            laserDupe.run(SKAction.sequence([spin,decay,remove]))
            
        } else {
            let decay = SKAction.wait(forDuration: TimeInterval(0.6 * Double(settings.mode)))
            let remove = SKAction.removeFromParent()
            laserDupe.run(SKAction.sequence([decay,remove]))
        }
        
        //MARK: Power Up that lasts the entire level!
        if doublelaser == 1 {
            let laser2 = 👁.copy()
            (laser2 as! SKSpriteNode).position = (CGPoint(x:superheroPositionX, y:superhero.position.y + 5))
            🚞.addChild(laser2 as! SKSpriteNode)
        }
        
        if settings.sound {
            let fire: SKAction = SKAction.playSoundFileNamed(🚨, waitForCompletion: false)
            laserDupe.run(fire)
            
        }
    }
    
  
    init(laserbeak 🌞:UInt32?, 🚞:SKScene?) {
        guard let 🌞 = 🌞, let 🚞 = 🚞 else { return }
        self.🌞 = 🌞
        self.🚞 = 🚞
    }
    
    init(bombsaway 🌞:UInt32?, 🚞:SKScene?) {
        guard let 🌞 = 🌞, let 🚞 = 🚞 else { return }
        self.🌞 = 🌞
        self.🚞 = 🚞
    }
    
    

    func bomb (superhero: (position:CGPoint, zRotation: CGFloat, velocity: CGVector), reverse: Bool ) {
        🛥 = !🛥
        
        💣 = SKSpriteNode()
        💣.position = (CGPoint(x:superhero.position.x, y:superhero.position.y - 10))
        
        //MARK: How to assign values in an Elvis Operator
        🔱 ? (💣.name = "🔱") : (💣.name = "💣")
        
        
        💣.isUserInteractionEnabled = false
        💣.physicsBody = 🦞
        💣.physicsBody?.affectedByGravity = true
        💣.physicsBody?.isDynamic = true
        💣.physicsBody?.affectedByGravity = true
        💣.physicsBody?.allowsRotation = true
        💣.physicsBody?.categoryBitMask = 64
        💣.physicsBody?.collisionBitMask = 4
        //let ctb = UInt32(2 + 8 + 16 + 256 + 512 + 1024 + 8192)
        let ctb = UInt32(14106)
        💣.physicsBody?.contactTestBitMask = ctb
        💣.physicsBody?.applyImpulse(CGVector(dx: 0,dy: 50))
        💣.physicsBody?.density = 0
        💣.physicsBody?.fieldBitMask = 0
        💣.physicsBody?.applyAngularImpulse(20)
        💣.physicsBody?.restitution = 0.5
        
        let wait = 800
        
        if reverse {
            💣.physicsBody?.velocity =  CGVector( dx: superhero.velocity.dx / 4, dy: 350)
        } else {
            💣.physicsBody?.velocity =  CGVector( dx: superhero.velocity.dx / 4, dy: -350 )
        }
        
        
        🛥 ? (💣.zPosition = 100) : (💣.zPosition = -100)
        
        🧨.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        🧨.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        🔱 ? (🧨.text = "🔱") : (🧨.text = "💩")
        
        🔱 && !reverse ? (🧨.yScale = -1) : ()
        
        🧨.fontSize = 32
        💣.addChild(🧨)
        💣.speed = 200
        
        let DaBomb = 💣.copy() as! SKSpriteNode
        🚞.addChild(DaBomb)
        
        
        let decay = SKAction.wait(forDuration: TimeInterval(wait))
        let remove = SKAction.removeFromParent()
        DaBomb.run(SKAction.sequence([decay,remove]))
        
        if settings.sound {
            let bombs: SKAction = SKAction.playSoundFileNamed(💥, waitForCompletion: false)
            DaBomb.run(bombs)
        }
    }
    
    func firebomb(firebomb:SKSpriteNode) {
        let fadeIn = SKAction.fadeAlpha(to: 0.5, duration:TimeInterval(0.3))
        let myDecay = SKAction.wait(forDuration: 0.5)
        let fadeOut = SKAction.fadeAlpha(to: 0.0001, duration:TimeInterval(0.6))
        firebomb.run(SKAction.sequence([fadeIn,myDecay,fadeOut]))
    }
    
    
    func getImageWithColorX(color: UIColor, size: CGSize) -> UIImage
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

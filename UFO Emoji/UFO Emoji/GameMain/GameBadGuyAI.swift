//
//  BadGuy.swift
//  UFEmoji
//
//  Created by Todd on 5/20/19.
//  Copyright © 2019 Todd Bruss. All rights reserved.
//


import SpriteKit

var badguyai: [String:CGPoint] = [:] // we clear this out later
var badguyArray = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","1","2","3","4","5","6","7","8","9","0","Ω","≈","ç","√","∫","˜","µ","å","ß","∂","ƒ","©","˙","∆","˚","¬"]
var badGuySecond = ["1","2"]
var badGuyThird =  ["3", "4"]
var badGuyFourth = ["5", "4"]
var badGuyFifth = ["3","2"]
//var badGuyCount = Int(0)


func DrawBadGuxAIX(TileMapParent: SKNode, TileNode: SKSpriteNode, PhysicsBody: SKPhysicsBody, Dynamic: Bool, Gravity: Bool, Category: UInt32, Collision: UInt32, Rotation: Bool, Emoji: String, Name: String, Contact: UInt32, Mass: CGFloat, Friction: CGFloat, Letter:String, Routes:Int, Nodes:Int ) {
 
    TileNode.physicsBody = PhysicsBody
    TileNode.zPosition = 70
    
    TileNode.physicsBody?.categoryBitMask = Category //2
    TileNode.physicsBody?.affectedByGravity = false //2
    TileNode.physicsBody?.collisionBitMask = Collision //2
    TileNode.physicsBody?.contactTestBitMask = Contact
    TileNode.physicsBody?.allowsRotation = Rotation //true
    TileNode.physicsBody?.pinned = false  //false
    TileNode.physicsBody?.friction = Friction
    TileNode.physicsBody?.mass = Mass
    TileNode.name = Name
    
    let homePosition = TileNode.position
    
    TileMapParent.addChild(TileNode)
    
    let codeaction = SKAction.run {
        
        var loop1 = 1
        var loop2 = 2
        
       	print("loop1",loop1,"loop2",loop2)
        
        let leaders = ["🤬","X"]
        
        if ( Name == leaders[0] || Name == leaders[1]) {
            
            TileNode.zPosition = 72
            TileNode.alpha = 1.0
            
            for _ in 0...1000 {
                let fifth1 = String(Int(arc4random_uniform(UInt32(Routes))) + 1)
                if  (  fifth1 != badGuyFourth[0] && fifth1 != badGuyThird[0] && fifth1 != badGuySecond[0] && fifth1 != loop1  ) {
                    badGuyFifth[0] = fifth1
                    break
                }
            }
            
            //alien in
            for _ in 0...1000 {
                let fifth2 = String(Int(arc4random_uniform(UInt32(Routes))) + 1)
                if  (  fifth2 != badGuyFourth[1] && fifth2 != badGuyThird[1] && fifth2 != badGuySecond[1] && fifth2 != loop2  ) {
                    badGuyFifth[1] = fifth2
                    break
                }
            }
            
        }
        
        // 😡 = Colonel
        let Colonels = ["🤯","X"]
        
        // 🤬 = Lieutenant
        let Lieutenants = ["😠","X"]
        
        // 😨 = General
        let Generals = ["😡","X"]
        
        // 😰 = Private and five routes
        let Privates = ["😨", "X"]
        
        if Name == Colonels[0] || Name ==  Colonels[1] {
            TileNode.zPosition = 74
            TileNode.alpha = 1.0
            
            loop1 = badGuySecond[0]
            loop2 = badGuySecond[1]
            
        } else if Name == Lieutenants[0] || Name == Lieutenants[1]  {
            TileNode.zPosition = 76
            
            loop1 = badGuyThird[0]
            loop2 = badGuyThird[1]
        } else if Name == Generals[0] || Name == Generals[1]  {
            TileNode.zPosition = 76
            
            loop1 = badGuyFourth[0]
            loop2 = badGuyFourth[1]
        } else if Name == Privates[0] || Name == Privates[1]  {
            TileNode.zPosition = 76
            
            loop1 = badGuyFifth[0]
            loop2 = badGuyFifth[1]
        }
        
        
        
        
        let point0h = homePosition //badguyai[String(Name) + String(Letter)]  //home position
        
        let path1 = UIBezierPath()
        
        
        if let _ = badguyai[String("📈") + loop1 + "1" + String(Letter)] {
            
        } else {
            print ("missing pt: " + String("📈") + loop1 + "1" + String(Letter))
            return
        }
        
        if let _  = badguyai[String("📈") + loop1 + "2" + String(Letter)] {
        } else {
             print ("missing pt: " + String("📈") + loop1 + "2" + String(Letter))
            return
        }
        
        if let _  = badguyai[String("📈") + loop1 + "3" + String(Letter)] {
        } else {
             print ("missing pt: " + String("📈") + loop1 + "3" + String(Letter))
            return
        }
        
        if let _  = badguyai[String("📈") + loop1 + "4" + String(Letter)] {
        } else {
            print ("missing pt: " + String("📈") + loop1 + "4" + String(Letter))
            return
        }
        
        if let _  = badguyai["📈\(loop1)5\(Letter)"] {
            
        } else {
            print ("missing pt: 📈\(loop1)5\(Letter)")
            print(badguyai)
            return
        }
        
        if let _  =  badguyai["📈\(loop2)5\(Letter)"] {
        } else {
            print ("missing pt: 📈\(loop2)5\(Letter)")
            print(badguyai)
            
            return
        }
        
        if let _  = badguyai[String("📈") + loop2 + "4" + String(Letter)] {
        } else {
            print ("missing pt: " + String("📈") + loop2 + "4" + String(Letter))
            
            return
        }
        
        if let _  = badguyai[String("📈") + loop2 + "3" + String(Letter)] {
        } else {
            print ("missing pt: " + String("📈") + loop2 + "3" + String(Letter))
            
            return
        }
        
        if let _  = badguyai[String("📈") + loop2 + "2" + String(Letter)] {
        } else {
            print ("missing pt: " + String("📈") + loop2 + "2" + String(Letter))
            
            return
        }
        
        if let _  = badguyai[String("📈") + loop2 + "1" + String(Letter)] {
        } else {
            print ("missing pt: " + String("📈") + loop2 + "1" + String(Letter))
            
            return
        }
        
         
        
        let point1a = badguyai[String("📈") + loop1 + "1" + String(Letter)]
        let point2a = badguyai[String("📈") + loop1 + "2" + String(Letter)]
        let point3a = badguyai[String("📈") + loop1 + "3" + String(Letter)]
        let point4a = badguyai[String("📈") + loop1 + "4" + String(Letter)]
        let point5a = badguyai[String("📈") + loop1 + "5" + String(Letter)]
        
        let point5b = badguyai[String("📈") + loop2 + "5" + String(Letter)]
        let point4b = badguyai[String("📈") + loop2 + "4" + String(Letter)]
        let point3b = badguyai[String("📈") + loop2 + "3" + String(Letter)]
        let point2b = badguyai[String("📈") + loop2 + "2" + String(Letter)]
        let point1b = badguyai[String("📈") + loop2 + "1" + String(Letter)]
        
        
        path1.move(to:point0h)
        
        if Nodes == 2 {
            path1.addQuadCurve(to: point2a!, controlPoint: point1a! )
            path1.addQuadCurve(to: point2b!, controlPoint: point1b! )
            path1.addQuadCurve(to: point0h, controlPoint: point1a! )
        } else if Nodes == 3 {
            path1.addQuadCurve(to: point2a!, controlPoint: point1a! )
            path1.addQuadCurve(to: point3b!, controlPoint: point2b! )
            path1.addQuadCurve(to: point0h, controlPoint: point1b! )
        } else if Nodes == 4 {
            path1.addQuadCurve(to: point2a!, controlPoint: point1a! )
            path1.addQuadCurve(to: point4a!, controlPoint: point3a! )
            path1.addQuadCurve(to: point4b!, controlPoint: point3b! )
            path1.addQuadCurve(to: point3b!, controlPoint: point2b! )
            path1.addQuadCurve(to: point0h, controlPoint: point1b! )
        } else if Nodes == 5 {
            path1.addQuadCurve(to: point2a!, controlPoint: point1a! )
            path1.addQuadCurve(to: point4a!, controlPoint: point3a! )
            path1.addQuadCurve(to: point5b!, controlPoint: point5a! )
            path1.addQuadCurve(to: point4b!, controlPoint: point3b! )
            path1.addQuadCurve(to: point3b!, controlPoint: point2b! )
            path1.addQuadCurve(to: point0h, controlPoint: point1b! )
        }
	
        //print(Nodes)
        
        let shape = SKShapeNode()
        shape.path = path1.cgPath
        shape.fillColor = UIColor.clear
        shape.strokeColor = UIColor.white
        shape.lineWidth = 1
        TileMapParent.addChild(shape)
        
        
        let moveToCurve1 = SKAction.follow(path1.cgPath, asOffset: false, orientToPath: false, duration: TimeInterval(5))
        let rep = SKAction.sequence([moveToCurve1])
        
        TileNode.run(rep)
    }
    
    
    let wait = SKAction.wait(forDuration: TimeInterval(5))
    let seq = SKAction.sequence([codeaction,wait])
    let rep = SKAction.repeatForever(seq)
    
    //TileNode.run(rep)
    
    let spriteLabelNode = SKLabelNode(fontNamed:"Apple Color Emoji")
    spriteLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
    spriteLabelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    spriteLabelNode.alpha = 1.0
    spriteLabelNode.position = CGPoint(x: 0, y: 0)
    spriteLabelNode.zPosition = 100
    
    spriteLabelNode.text = String(Emoji)
    spriteLabelNode.fontSize = 42
    TileNode.addChild(spriteLabelNode)
    
}


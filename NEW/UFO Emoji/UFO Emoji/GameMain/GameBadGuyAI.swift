//
//  BadGuy.swift
//  UFEmoji
//
//  Created by Todd on 5/20/19.
//  Copyright © 2019 Todd Bruss. All rights reserved.
//


import SpriteKit

var badguyai: [String:CGPoint] = [:] // we clear this out later
var badguyArray = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
var badGuySecond = ["1","2"]
var badGuyThird =  ["2","3"]
var badGuyFourth = ["3","4"]
var badGuyFifth = ["4","5"]
//var badGuyCount = Int(0)


func DrawBadGuxAI(TileMapParent: SKNode, TileNode: SKSpriteNode, PhysicsBody: SKPhysicsBody, Dynamic: Bool, Gravity: Bool, Category: UInt32, Collision: UInt32, Rotation: Bool, Emoji: String, Name: String, Contact: UInt32, Mass: CGFloat, Friction: CGFloat, Letter:String, Routes:Int, Nodes:Int ) {
 
    TileNode.physicsBody = PhysicsBody
    TileNode.zPosition = 70
    
    TileNode.physicsBody?.categoryBitMask = Category //2
    TileNode.physicsBody?.affectedByGravity = false //2
    //TileNode.physicsBody?.allowsRotation = false  //fals
    TileNode.physicsBody?.collisionBitMask = Collision //2
    TileNode.physicsBody?.contactTestBitMask = Contact
    TileNode.physicsBody?.allowsRotation = Rotation //true
    TileNode.physicsBody?.pinned = false  //false
    TileNode.physicsBody?.friction = Friction
    TileNode.physicsBody?.mass = Mass
    TileNode.name = Name
    
    let homePosition = TileNode.position
    //let name = TileMapNode.name
    //let scene = TileMapNode.scene
    //let world = scene?.childNode(withName: "world")?.childNode(withName: name!)
    
    TileMapParent.addChild(TileNode)
    
    let codeaction = SKAction.run {
        
        var loop1 = String(Int(arc4random_uniform(UInt32(Routes))) + 1)
        var loop2 = String(Int(arc4random_uniform(UInt32(Routes))) + 1)
        
        // 😠 = Leader and three routes
        // 🤯 = Leader and five routes
        
        let leaders = ["😠","🤯"]
        
        if ( Name == leaders[0] || Name == leaders[1]) {
            
            TileNode.zPosition = 72
            TileNode.alpha = 1.0
            //smile out
            
            if Routes >= 2 {
                for _ in 1...100 {
                    let second1 = String(Int(arc4random_uniform(UInt32(Routes))) + 1)
                    if  ( second1 != loop1 ) {
                        badGuySecond[0] = second1
                        break
                    }
                }
                
                //smile in
                for _ in 1...100 {
                    let second2 = String(Int(arc4random_uniform(UInt32(Routes))) + 1)
                    if  ( second2 != loop2 ) {
                        badGuySecond[1] = second2
                        break
                    }
                }
            }
            
            if Routes >= 3 {
                //alien out
                for _ in 1...100 {
                    let third1 = String(Int(arc4random_uniform(UInt32(Routes))) + 1)
                    if  ( third1 != badGuySecond[0] && third1 != loop1  ) {
                        badGuyThird[0] = third1
                        break
                    }
                }
                
                //alien in
                for _ in 1...100 {
                    let third2 = String(Int(arc4random_uniform(UInt32(Routes))) + 1)
                    if  ( third2 != badGuySecond[1] && third2 != loop2  ) {
                        badGuyThird[1] = third2
                        break
                    }
                }
            }
            
            if Routes >= 4 {
                //alien out
                for _ in 1...100 {
                    let fourth1 = String(Int(arc4random_uniform(UInt32(Routes))) + 1)
                    if  (  fourth1 != badGuyThird[0] && fourth1 != badGuySecond[0] && fourth1 != loop1  ) {
                        badGuyFourth[0] = fourth1
                        break
                    }
                }
                
                //alien in
                for _ in 1...100 {
                    let forth2 = String(Int(arc4random_uniform(UInt32(Routes))) + 1)
                    if  (  forth2 != badGuyThird[1] && forth2 != badGuySecond[1] && forth2 != loop2  ) {
                        badGuyFourth[1] = forth2
                        break
                    }
                }
            }
            
            if Routes >= 5 {
                //alien out
                for _ in 1...100 {
                    let fifth1 = String(Int(arc4random_uniform(UInt32(Routes))) + 1)
                    if  (  fifth1 != badGuyFourth[0] && fifth1 != badGuyThird[0] && fifth1 != badGuySecond[0] && fifth1 != loop1  ) {
                        badGuyFifth[0] = fifth1
                        break
                    }
                }
                
                //alien in
                for _ in 1...100 {
                    let fifth2 = String(Int(arc4random_uniform(UInt32(Routes))) + 1)
                    if  (  fifth2 != badGuyFourth[1] && fifth2 != badGuyThird[1] && fifth2 != badGuySecond[1] && fifth2 != loop2  ) {
                        badGuyFifth[1] = fifth2
                        break
                    }
                }
            }
            
            
        }
        
        // 😡 = Colonel and three routes
        // 😳 = Colonel and five routes
        let Colonels = ["😡","😳"]
        
        // 🤬 = Lieutenant and three routes
        // 😱 = Lieutenant and five routes
        let Lieutenants = ["🤬","😱"]
        
        
        // 😨 = General and five routes
        let Generals = ["X","😨"]
        
        // 😰 = Private and five routes
        let Privates = ["😰"]
        
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
        } else if Name == Privates[0]  {
            TileNode.zPosition = 76
            
            loop1 = badGuyFifth[0]
            loop2 = badGuyFifth[1]
        }
        
        
        
        
        let point0h = homePosition //badguyai[String(Name) + String(Letter)]  //home position
        
        let path1 = UIBezierPath()
        
        
        
        if let _ = badguyai[String("📈") + loop1 + "1" + String(Letter)] {
            
        } else {
            //print ("missing pt: " + String("📈") + loop1 + "1" + String(Letter))
            return
        }
        
        if let _  = badguyai[String("📈") + loop1 + "2" + String(Letter)] {
        } else {
            // print ("missing pt: " + String("📈") + loop1 + "2" + String(Letter))
            return
        }
        
        if let _  = badguyai[String("📈") + loop1 + "3" + String(Letter)] {
        } else {
            // print ("missing pt: " + String("📈") + loop1 + "3" + String(Letter))
            return
        }
        
        if let _  = badguyai[String("📈") + loop1 + "4" + String(Letter)] {
        } else {
            // print ("missing pt: " + String("📈") + loop1 + "4" + String(Letter))
            return
        }
        
        if let _  = badguyai[String("📈") + loop1 + "5" + String(Letter)] {
            
        } else {
            print ("missing pt: " + String("📈") + loop1 + "5" + String(Letter))
            print(badguyai)
            return
        }
        
        if let _  = badguyai[String("📈") + loop2 + "5" + String(Letter)] {
        } else {
            print ("missing pt: " + String("📈") + loop1 + "5" + String(Letter))
            print(badguyai)
            
            return
        }
        
        if let _  = badguyai[String("📈") + loop2 + "4" + String(Letter)] {
        } else {
            //print ("missing pt: " + String("📈") + loop2 + "4" + String(Letter))
            
            return
        }
        
        if let _  = badguyai[String("📈") + loop2 + "3" + String(Letter)] {
        } else {
            //print ("missing pt: " + String("📈") + loop2 + "3" + String(Letter))
            
            return
        }
        
        if let _  = badguyai[String("📈") + loop2 + "2" + String(Letter)] {
        } else {
            //print ("missing pt: " + String("📈") + loop2 + "2" + String(Letter))
            
            return
        }
        
        if let _  = badguyai[String("📈") + loop2 + "1" + String(Letter)] {
        } else {
            //print ("missing pt: " + String("📈") + loop2 + "1" + String(Letter))
            
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
        //path1.addCurve(to: point0h, controlPoint1: CGPoint(x:point1b!.x - variant,y:point1b!.y + variant), controlPoint2: CGPoint(x:point1a!.x - variant,y:point1a!.y + variant))
        //func addQuadCurve(to endPoint: CGPoint, controlPoint: CGPoint)
        
        
        // let node1 = SKShapeNode(path:path1.cgPath)
        //node1.strokeColor = UIColor.clear
        // TileMapNode.parent?.addChild(node1)
        //node1.position = point0h
        //TileNode.position = CGPoint (x:node1.position.x - (point0h.x), y:node1.position.y - (point0h.y))
        //node1.position = TileNode.position
        
        
        // let removenode = SKAction.run {
        //    node1.removeFromParent()
        //}
        
        let moveToCurve1 = SKAction.follow(path1.cgPath, asOffset: false, orientToPath: false, duration: TimeInterval(5))
        let rep = SKAction.sequence([moveToCurve1])
        
        //if (TileNode.intersects(TileNode.parent!)) {
        TileNode.run(rep)
        //}
        
    }
    
    
    
    
    let wait = SKAction.wait(forDuration: TimeInterval(5))
    let seq = SKAction.sequence([codeaction,wait])
    let rep = SKAction.repeatForever(seq)
    
    TileNode.run(rep)
    
    let spriteLabelNode = SKLabelNode(fontNamed:"Apple Color Emoji")
    spriteLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
    spriteLabelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    spriteLabelNode.alpha = 1.0
    spriteLabelNode.position = CGPoint(x: 0, y: 0)
    //spriteLabelNode.xScale = fliph ? -1 : 1
    //spriteLabelNode.yScale = flipy ? -1 : 1
    spriteLabelNode.zPosition = 100
    
    spriteLabelNode.text = String(Emoji)
    spriteLabelNode.fontSize = 42
    TileNode.addChild(spriteLabelNode)
    
}


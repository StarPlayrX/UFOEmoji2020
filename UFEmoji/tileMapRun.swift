//
//  tileMapRun.swift
//  UF Emoji
//
//  Created by Todd Bruss on 4/23/17.
//  Copyright © 2017 Todd Bruss. All rights reserved.
//

import SpriteKit
//var earth = SKSpriteNode()

class TMR {
    
    var TileMap: SKTileMapNode

    init(TileMap: SKTileMapNode) {
        
        self.TileMap = TileMap

    }
    
    //Draw Coins
    func DrawCoins(TileNode: SKSpriteNode, PhysicsBody: SKPhysicsBody, Dynamic: Bool, Gravity: Bool, Category: UInt32, Collision: UInt32, Rotation: Bool, Emoji: String, Name: String, Contact: UInt32, Mass: CGFloat, Friction: CGFloat, NewItem: String, fliph: Bool, flipy: Bool) {
        
        TileNode.physicsBody = PhysicsBody
        TileNode.zPosition = 75
        TileNode.physicsBody?.restitution = 0.5
        
     
        if NewItem == "🐟" || Name == "💢" || Name == "🛑" || Name == "♨️" || Emoji == "🐝" || NewItem == "🦀" || Emoji == "🌈" {
            TileNode.zPosition = -20
            TileNode.physicsBody?.affectedByGravity = false //true
            TileNode.physicsBody?.isDynamic = false //false
        } else if Name == "🖲" {
            TileNode.physicsBody?.affectedByGravity = true //true
            TileNode.physicsBody?.isDynamic = true //false
            TileNode.physicsBody?.fieldBitMask = 16384
            TileNode.physicsBody?.restitution = 1.0
        } else if NewItem == "🛸" {
            TileNode.zPosition = 91
            TileNode.physicsBody?.affectedByGravity = true //true
            TileNode.physicsBody?.isDynamic = false //false
        }
        
        TileNode.physicsBody?.categoryBitMask = Category //2
        TileNode.physicsBody?.collisionBitMask = Collision //2
        TileNode.physicsBody?.contactTestBitMask = Contact
        TileNode.physicsBody?.allowsRotation = Rotation //true
        TileNode.physicsBody?.pinned = false  //false
        TileNode.physicsBody?.isResting = false
        TileNode.physicsBody?.friction = Friction
        TileNode.physicsBody?.mass = Mass
        TileNode.name = Name
        
        //let name = TileMapNode.name
        //let scene = TileMapNode.scene
        //let world = scene?.childNode(withName: "world")?.childNode(withName: name!)
        //world?.addChild(TileNode)
        TileMap.parent?.addChild(TileNode)
        
        if NewItem == "🐟" || Emoji == "🐝" || NewItem == "🦀" || NewItem == "🛸"  {
            var random = Int(arc4random_uniform(6)) + 1
            let r2 = Int(arc4random_uniform(1))
            
            var mov = -1
            
            if r2 == 1 {
                mov = 1
            }
            
            if Name == "🐝" || Name == "🛸" {
                random = random / 2
            }
            
            let moveAmount = 32 * random
            let moveright = SKAction.move(by: CGVector(dx: moveAmount * mov, dy: 0), duration: TimeInterval(random))
            let wait = SKAction.wait(forDuration: TimeInterval(random))
            let flip1 = SKAction.scaleX(to: CGFloat(mov), duration: 0.5)
            let flip2 = SKAction.scaleX(to: CGFloat(-mov), duration: 0.5)
            let moveleft = SKAction.move(by: CGVector(dx: moveAmount * -mov, dy: 0), duration: TimeInterval(random))
            
            let rep = SKAction.repeatForever(SKAction.sequence([flip2,moveright,wait,flip1,wait,moveleft,wait]))
            TileNode.run(rep)
        }
        
        let spriteLabelNode = SKLabelNode(fontNamed:"Apple Color Emoji")
        spriteLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        spriteLabelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        spriteLabelNode.alpha = 1.0
        spriteLabelNode.position = CGPoint(x: 0, y: 0)
        spriteLabelNode.xScale = fliph ? -1 : 1
        spriteLabelNode.yScale = flipy ? -1 : 1
        
        
        var str = Emoji //may include variants at random or for holidays
        spriteLabelNode.fontSize = 32
        
        switch NewItem {

        case "🐟":
            spriteLabelNode.zPosition = -20
        case "☄️":
            spriteLabelNode.fontSize = 40
        default:
            spriteLabelNode.fontSize = 36
        }
        
        switch Emoji {
            
        case "🚀":
            spriteLabelNode.zRotation = CGFloat(Double.pi/4)
            spriteLabelNode.xScale = -1
        case "🛸":
             spriteLabelNode.xScale = -1
            spriteLabelNode.zRotation = CGFloat(Double.pi/9)
            spriteLabelNode.fontSize = 50
        case "🧟‍♀️","🧟‍♂️":
            spriteLabelNode.fontSize = 42
        case "🎱","🥚","💀","⚽️","🏈","🍊","🍏","🍎","🍅","🍈","🍋","🍑","🍓","🥥","🍩":
            TileNode.physicsBody?.allowsRotation = true
            TileNode.physicsBody?.friction = 1
        case "🐌":
            spriteLabelNode.xScale = -1
        case "☄️":
            spriteLabelNode.zRotation = CGFloat(-Double.pi/4)
        case "🦔":
            spriteLabelNode.fontSize = 40
            spriteLabelNode.yScale = 1.25
        case "😱":
            let coinToss = arc4random_uniform(2) == 0
            str = coinToss ? "😱" : "🙀"
        case "🌿":
            let coinToss = arc4random_uniform(2) == 0
            str = coinToss ? "🌿" : "🌱"
        case "🍀":
            let coinToss = arc4random_uniform(2) == 0
            str = coinToss ? "🍀" : "☘️"
        case "🤴","👸":
            if KingQueenGlobalDie == 100 {
                KingQueenGlobalDie = Int(arc4random_uniform(4))
            }
            
            if Emoji == "🤴" {
                switch KingQueenGlobalDie {
                case 0:
                    str = "🤴🏻"
                case 1:
                    str = "🤴🏼"
                case 2:
                    str = "🤴🏽"
                case 3:
                    str = "🤴"
                default:
                    str = "🤴🏻"
                }
            } else {
                switch KingQueenGlobalDie {
                case 0:
                    str = "👸🏻"
                case 1:
                    str = "👸🏼"
                case 2:
                    str = "👸🏽"
                case 3:
                    str = "👸"
                default:
                    str = "👸🏻"
                }
            }
            
        case "🏯":
            let coinToss = arc4random_uniform(2) == 0
            str = coinToss ? "⛩" : "🏯"
        case "💢", "🎇", "🌀", "♨️", "🛑":
            str = "" // No Emoji
        case "‼️","🔫":
            str = "🔫" // Gun
        case "🦎":
            spriteLabelNode.xScale = -1
        case "❣️":
            str = heroArray[settings.emoji];
        default:
            str = Emoji
        }
        
        //if the item is on the left side and this is a center section, flip it
        if TileNode.position.x < 0 && NewItem != "🛸"  {
            spriteLabelNode.xScale *= -1
        }
        
        
        spriteLabelNode.text = str
        
        //We don't want to flip stuff with writing on it
        //Because it's backwards
        if (str == "💰" || str == "🎰" || str == "💵"  || str == "🤑") {
            spriteLabelNode.xScale = 1
        }
        
        TileNode.addChild(spriteLabelNode)
        
        // = Field
        if Name == "💢" {
            let 💢 = SKFieldNode.springField()
            💢.strength = 1.0
            💢.minimumRadius = 320 + 32;
            💢.position = CGPoint(x:0,y:0)
            if let 🎱 = SKShapeNode(circleOfRadius: 320 + 32).path {
                💢.region = SKRegion(path: 🎱)
                💢.categoryBitMask = 16384;
                TileNode.addChild(💢)
            }
        }
        
        
        // = 🛑 StarField (Space Mini Game Gravity Pull)
        if Name == "🛑" {
            //let 💢 = SKFieldNode.noiseField(withSmoothness: 0.5, animationSpeed: 0.5)
            let 💢 = SKFieldNode.radialGravityField()
            💢.strength = 0.1
            💢.falloff = -0.05
            💢.minimumRadius = 1400 ;
            💢.position = CGPoint(x:16,y:16)
            if let 🎱 = SKShapeNode(circleOfRadius: 1400).path {
                💢.region = SKRegion(path: 🎱)
                💢.categoryBitMask = 2 + 8 + 64 + 256 + 512 + 1024 //    16384;
                TileNode.addChild(💢)
            }
            
            
            //prevent stuff from going all the way in
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0,y: 0), radius: 128, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            TileNode.physicsBody = SKPhysicsBody(edgeLoopFrom: circlePath.cgPath)
            TileNode.physicsBody!.categoryBitMask = 2 + 8 + 64 + 256 + 512 + 1024
            TileNode.physicsBody!.collisionBitMask = 0
            TileNode.physicsBody?.restitution = 0.02
            TileNode.physicsBody!.contactTestBitMask = 0
        }
        
        if Name == "🎇" {
            let field = SKFieldNode.springField()
            field.strength = 0.2
            field.minimumRadius = Float((TileMap.scene?.frame.height)! / 4)
            field.position = CGPoint(x:0,y:0)
            let shape = SKShapeNode(circleOfRadius: 256)
            field.region = SKRegion(path: shape.path!)
            field.categoryBitMask = 1
            field.physicsBody?.contactTestBitMask = 1
            TileNode.physicsBody?.affectedByGravity = false //true
            TileNode.physicsBody?.isDynamic = false //false
            TileNode.physicsBody?.categoryBitMask = 2048
            TileNode.physicsBody?.collisionBitMask = 0
            TileNode.addChild(field)
            field.zPosition = 1000
            
            //particle emitter
            if let blackhole = SKEmitterNode(fileNamed: "blackHole") {
                blackhole.alpha = 0.5
                blackhole.speed = 5
                blackhole.name = "levelup"
                blackhole.setScale(0.334)
                TileNode.addChild(blackhole)
            }
            
        }
        
        /* portal to a mini game */
        if Name == "🌀" {
            let field = SKFieldNode.springField()
            field.strength = 0.2
            field.minimumRadius = Float((TileMap.scene?.frame.height)! / 8)
            field.position = CGPoint(x:0,y:0)
            let shape = SKShapeNode(circleOfRadius: 128)
            field.region = SKRegion(path: shape.path!)
            field.categoryBitMask = 1
            field.physicsBody?.contactTestBitMask = 1
            TileNode.physicsBody?.affectedByGravity = false //true
            TileNode.physicsBody?.isDynamic = false //false
            TileNode.physicsBody?.categoryBitMask = 2048
            TileNode.physicsBody?.collisionBitMask = 0
            TileNode.addChild(field)
            field.zPosition = 1000
            
            //particle emitter
            if let blackhole = SKEmitterNode(fileNamed: "minigamehole") {
                blackhole.alpha = 0.5
                blackhole.speed = 2
                blackhole.name = "minigamelevelup"
                blackhole.setScale(0.25)
                TileNode.addChild(blackhole)
            }
        }
    }
    
    //Tile Map Run
    func tileMapRun(tileDefinition: SKTileDefinition, center: CGPoint, leftside: Bool = false
, flipsection: Bool = false, centerSection:Bool = true) {
        var name = String()
        let ds = DS(TileMap: TileMap)

        if let x = tileDefinition.name {
            name = x //gets the Sprite name
        }
        
        let tileData = tileDefinition.userData
        
        var centerTexture = SKTexture()
        var newname = String()
        var newitem = String()
        var newemoji = String()
        var bgroutes = Int()
        var bgnodes = Int()
        
        var tileNode = SKSpriteNode()
        
        //Good guys and Badguys are three characters
        if name.count == 3 {
            var index = 0
            for character in name {
                index = index + 1
                if index == 1 {
                    newname = String(character)
                } else if index == 2 {
                    newitem = String(character)
                } else if index == 3 {
                    newemoji = String(character)
                }
            }
        } else {
            centerTexture = SKTexture(imageNamed: name)
            tileNode = SKSpriteNode(texture: centerTexture)
        }
        
        tileNode.position = center
        
        //* This is the symbol of our baddie *//
        
        // 👾 = BadyGuy
        if ( newname == "👾" ) {
            
            centerTexture = SKTexture()
            tileNode =  SKSpriteNode()
            tileNode.position = center
            
            for i in 1...100 {
                //print("i: " + String(i))
                if badguyai[newitem + String(badguyArray[i])] == nil {
                    let pos = tileNode.position
                    badguyai[newitem + String(badguyArray[i])] = pos // we are now setting the home position, but we are storing this for the drive Letter
                    
                    let gravity = false;
                    let radius = TileMap.tileSize.width / 2.0 - 2.0
                    let physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(radius))
                    let rotation = true;
                    
                    //let fliph = tileDefinition.flipHorizontally
                    //let flipy = tileDefinition.flipVertically
                    let cat = 16 as UInt32
                    let col = 0  as UInt32
                    let con = 1 + 64 as UInt32
                    bgroutes = 2 //tileData?["routes"] as! Int
                    bgnodes = 2 //tileData?["nodes"] as! Int
                    
                    //Item determines routes and nodes
                    // 😠 = Leader and three routes
                    // 😡 = Lieutenant and three routes
                    // 🤬 = Private and three routes
                    if newitem == "😠" || newitem == "😡" || newitem == "🤬" {
                        bgroutes = 3 //tileData?["routes"] as! Int
                        bgnodes = 3 //tileData?["nodes"] as! Int
                    }
                    
                    //Item determines routes and nodes
                    // 🤯 = Leader and five routes
                    // 😳 = Colonel and five routes
                    // 😱 = Lieutenant and five routes
                    // 😨 = General and five routes
                    // 😰 = Private and five routes
                    if newitem == "🤯" || newitem == "😳" || newitem == "😱" || newitem == "😨" || newitem == "😰" {
                        
                        // print(newitem)
                        
                        bgroutes = 5 //tileData?["routes"] as! Int
                        bgnodes = 5 //tileData?["nodes"] as! Int
                    }
                    
                    DrawBadGuxAI(TileMapNode: TileMap, TileNode: tileNode, PhysicsBody: physicsBody, Dynamic: true, Gravity: gravity, Category: cat, Collision: col, Rotation: rotation, Emoji: newemoji, Name: newitem, Contact: con, Mass: 0.1, Friction: 0, Letter: String(badguyArray[i]), Routes: bgroutes, Nodes: bgnodes )
                    
                    break;
                }
            }
            
            // see if we can remove the count here
        } else if ( newname == "📈" ) {
            
            for i in 1...5 {
                if badguyai[(name) + String(badguyArray[i])] == nil {
                    let pos = tileNode.position
                    badguyai[(name) + String(badguyArray[i])] = pos
                    break;
                }
            }
            
        } else if ( tileData?["isGrass"] as? Bool == true )  {
            
            centerTexture = SKTexture(imageNamed: name + "top2")
            tileNode = SKSpriteNode(texture: centerTexture)
            tileNode.position = center
            tileNode.position.y = tileNode.position.y + 8
            
            var stagename = tileData?["name"] as! String
            var physicsBody = SKPhysicsBody(rectangleOf: tileNode.size, center: CGPoint(x: 0, y: 0))
            
            ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: stagename, Attribute: 2)

            /* A2 set */
            centerTexture = SKTexture(imageNamed: name + "btm3")
            tileNode =  SKSpriteNode(texture: centerTexture)
            tileNode.position = center
            tileNode.position.y = tileNode.position.y - 8
            
            physicsBody = SKPhysicsBody(rectangleOf: tileNode.size, center: CGPoint(x: 0, y: 0))
            
            stagename = "dirt"
            ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: stagename, Attribute: 2)

        } else if ( tileData?["isDirt"] as? Bool == true || tileData?["isStone"] as? Bool == true  )  {
            
            let halfwidth = centerTexture.size().width / 2
            let halfheight = centerTexture.size().height / 2
            let width = centerTexture.size().width
            let height = centerTexture.size().height
            
            let coinToss = Int(arc4random_uniform(3)) + 1 //4
            if coinToss == 1 || coinToss == 2 {
                /* A1 set */
                let upperLeft = CGPoint(x: 0 - halfwidth, y: height - halfheight)
                let upperRight = CGPoint(x: width - halfwidth, y: height - halfheight)
                let middleLeft   =  CGPoint(x: 0 - halfwidth, y: 0 )
                let middleRight  =  CGPoint(x: width - halfwidth, y: 0  )
                let lowerLeft   = CGPoint(x: 0 - halfwidth , y: 0 - halfheight)
                let lowerRight  = CGPoint(x: width - halfwidth, y: 0 - halfheight) //this is the only new point in the set
                
                centerTexture = SKTexture(imageNamed: name + "1")
                tileNode =  SKSpriteNode(texture: centerTexture)
                tileNode.position = center
                
                var path = CGMutablePath()
                
                path.addLines(between: [
                    upperLeft, upperRight,
                    middleRight, middleLeft
                    ]
                )
                
                path.closeSubpath()
                var physicsBody = SKPhysicsBody(polygonFrom: path)
                
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: name, Attribute: 2)

                /* A2 set */
                centerTexture = SKTexture(imageNamed: name + "2")
                tileNode =  SKSpriteNode(texture: centerTexture)
                tileNode.position = center
                
                path = CGMutablePath()
                path.addLines(between: [
                    middleLeft, middleRight,
                    lowerRight, lowerLeft
                    ]
                )
                
                path.closeSubpath()
                physicsBody = SKPhysicsBody(polygonFrom: path)
                
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: name, Attribute: 2)
            } else if coinToss == 99  {
                
                //MARK: 5 UpperLeftCorner
                let upperLeft = CGPoint(x: 0 - halfwidth, y: height - halfheight)
                let upperRight = CGPoint(x: width - halfwidth, y: height - halfheight)
                let topMiddle = CGPoint(x: 0, y: height - halfheight )
                let btmMiddle = CGPoint(x: 0, y: 0 - halfheight )
                let middleLeft = CGPoint(x: 0 - halfwidth, y: 0 )
                let middleRight = CGPoint(x: width - halfwidth, y: 0  )
                let lowerLeft = CGPoint(x: 0 - halfwidth , y: 0 - halfheight)
                let lowerRight = CGPoint(x: width - halfwidth, y: 0 - halfheight) //this is the only new point in the set
                let centerMost = CGPoint(x: 0, y: 0)
                
                centerTexture = SKTexture(imageNamed: name + "5")
                tileNode =  SKSpriteNode(texture: centerTexture)
                
                tileNode.position = center
                
                var path = CGMutablePath()
                
                path.addLines(between: [
                    upperLeft, topMiddle,
                    centerMost, middleLeft
                    ]
                )
                
                path.closeSubpath()
                
                var physicsBody = SKPhysicsBody(polygonFrom: path)
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: name, Attribute: 4)
                //mark: 6 UpperRightCorner
                centerTexture = SKTexture(imageNamed: name + "6")
                tileNode =  SKSpriteNode(texture: centerTexture)
                tileNode.position = center
                
                path = CGMutablePath()
                path.addLines(between: [
                    topMiddle, upperRight,
                    middleRight, centerMost
                    ]
                )
                
                path.closeSubpath()
                physicsBody = SKPhysicsBody(polygonFrom: path)
                
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: name, Attribute: 4)

                
                //mark: 7 LowerLeftCorner
                centerTexture = SKTexture(imageNamed: name + "7")
                tileNode =  SKSpriteNode(texture: centerTexture)
                tileNode.position = center
                
                path = CGMutablePath()
                path.addLines(between: [
                    middleLeft, centerMost,
                    btmMiddle, lowerLeft
                    ]
                )
                
                path.closeSubpath()
                physicsBody = SKPhysicsBody(polygonFrom: path)
                
                
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: name, Attribute: 4)

                //mark: 8 LowerRightCorner
                centerTexture = SKTexture(imageNamed: name + "8")
                tileNode =  SKSpriteNode(texture: centerTexture)
                tileNode.position = center
                
                path = CGMutablePath()
                path.addLines(between: [
                    centerMost, middleRight,
                    lowerRight, btmMiddle
                    ]
                )
                
                path.closeSubpath()
                physicsBody = SKPhysicsBody(polygonFrom: path)
                
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: name, Attribute: 4)

            } else if coinToss == 3  {
                /* A1 set */
                let upperLeft = CGPoint(x: 0 - halfwidth, y: height - halfheight)
                let upperRight = CGPoint(x: width - halfwidth, y: height - halfheight)
                
                let topMiddle = CGPoint(x: 0, y: height - halfheight )
                let btmMiddle = CGPoint(x: 0, y: 0 - halfheight )
                
                let lowerLeft = CGPoint(x: 0 - halfwidth , y: 0 - halfheight)
                let lowerRight = CGPoint(x: width - halfwidth, y: 0 - halfheight) //this is the only new point in the set
                
                centerTexture = SKTexture(imageNamed: name + "3")
                tileNode =  SKSpriteNode(texture: centerTexture)
                
                tileNode.position = center
                
                var path = CGMutablePath()
                
                path.addLines(between: [
                    upperLeft, topMiddle,
                    btmMiddle, lowerLeft
                    ]
                )
                
                path.closeSubpath()
                
                /// let stagename = tileData?["name"] as! String
                
                var physicsBody = SKPhysicsBody(polygonFrom: path)
                
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: name, Attribute: 2)

                /* A2 set */
                
                centerTexture = SKTexture(imageNamed: name + "4")
                tileNode =  SKSpriteNode(texture: centerTexture)
                tileNode.position = center
                
                path = CGMutablePath()
                path.addLines(between: [
                    topMiddle, upperRight,
                    lowerRight, btmMiddle
                    ]
                )
                
                path.closeSubpath()
                physicsBody = SKPhysicsBody(polygonFrom: path)
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: name, Attribute: 2)

            } else {
                /* A1 set */
                let upperLeft = CGPoint(x: 0 - halfwidth, y: height - halfheight)
                let upperRight = CGPoint(x: width - halfwidth, y: height - halfheight)
                
                let lowerLeft = CGPoint(x: 0 - halfwidth , y: 0 - halfheight)
                let lowerRight = CGPoint(x: width - halfwidth, y: 0 - halfheight) //this is the only new point in the set
                
                centerTexture = SKTexture(imageNamed: name)
                
                //print(name)
                tileNode = SKSpriteNode(texture: centerTexture)
                
                tileNode.position = center
                
                let path = CGMutablePath()
                
                path.addLines(between: [
                    upperLeft, upperRight,
                    lowerRight, lowerLeft
                    ]
                )
                
                path.closeSubpath()
                
                let physicsBody = SKPhysicsBody(polygonFrom: path)
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: name, Attribute: 1)
            }
        } else if ( tileData?["isQtr"] as? Bool == true )  {
            
            let halfwidth = centerTexture.size().width / 2
            let halfheight = centerTexture.size().height / 2
            
            let width = centerTexture.size().width
            let height = centerTexture.size().height
            
            //mark: 5 UpperLeftCorner
            let upperLeft = CGPoint(x: 0 - halfwidth, y: height - halfheight)
            let upperRight = CGPoint(x: width - halfwidth, y: height - halfheight)
            
            let topMiddle = CGPoint(x: 0, y: height - halfheight )
            let btmMiddle = CGPoint(x: 0, y: 0 - halfheight )
            let middleLeft = CGPoint(x: 0 - halfwidth, y: 0 )
            let middleRight = CGPoint(x: width - halfwidth, y: 0  )
            
            let lowerLeft = CGPoint(x: 0 - halfwidth , y: 0 - halfheight)
            let lowerRight = CGPoint(x: width - halfwidth, y: 0 - halfheight) //this is the only new point in the set
            
            let centerMost = CGPoint(x: 0, y: 0)
            
            var path = CGMutablePath()
            
            let stagename = tileData?["name"] as! String
            
            if (tileData?["sector"] as? UInt32) == 5 {
                centerTexture = SKTexture(imageNamed: name)
                tileNode =  SKSpriteNode(texture: centerTexture)
                
                tileNode.position = center
                
                path.addLines(between: [
                    upperLeft, topMiddle,
                    centerMost, middleLeft
                    ]
                )
                
                path.closeSubpath()
                
                let physicsBody = SKPhysicsBody(polygonFrom: path)
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: stagename, Attribute: 4)
            }
            
            //mark: 6 UpperRightCorner
            if (tileData?["sector"] as? UInt32) == 6 {
                centerTexture = SKTexture(imageNamed: name)
                tileNode =  SKSpriteNode(texture: centerTexture)
                tileNode.position = center
                
                path = CGMutablePath()
                path.addLines(between: [
                    topMiddle, upperRight,
                    middleRight, centerMost
                    ]
                )
                
                path.closeSubpath()
                
                let physicsBody = SKPhysicsBody(polygonFrom: path)
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: stagename, Attribute: 4)
            }
            
            //mark: 7 LowerLeftCorner
            if (tileData?["sector"] as? UInt32) == 7 {
                centerTexture = SKTexture(imageNamed: name)
                tileNode =  SKSpriteNode(texture: centerTexture)
                tileNode.position = center
                
                path = CGMutablePath()
                path.addLines(between: [
                    middleLeft, centerMost,
                    btmMiddle, lowerLeft
                    ]
                )
                
                path.closeSubpath()
                let physicsBody = SKPhysicsBody(polygonFrom: path)
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: stagename, Attribute: 4)
            }
            
            //MARK: 8 LowerRightCorner
            if (tileData?["sector"] as? UInt32) == 8  {
                centerTexture = SKTexture(imageNamed: name)
                tileNode =  SKSpriteNode(texture: centerTexture)
                tileNode.position = center
                
                path = CGMutablePath()
                path.addLines(between: [
                    centerMost, middleRight,
                    lowerRight, btmMiddle
                    ]
                )
                
                path.closeSubpath()
                let physicsBody = SKPhysicsBody(polygonFrom: path)
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: stagename, Attribute: 4)
            }
            
        } else if ( tileData?["isGrassCorner"] as? Bool == true )  {
            
            let halfwidth = centerTexture.size().width / 2
            let halfheight = centerTexture.size().height / 2
            let width = centerTexture.size().width
            let height = centerTexture.size().height
            let upperLeft   =   CGPoint(x: 0 - halfwidth, y: height - halfheight)
            let upperRight  =   CGPoint(x: width - halfwidth, y: height - halfheight)
            let lowerLeft   =   CGPoint(x: 0 - halfwidth , y: 0 - halfheight)
            let lowerRight  =   CGPoint(x: width - halfwidth, y: 0 - halfheight)
            let centerMost  =   CGPoint(x: 0, y: 0 )
            let middleLeft  =   CGPoint(x: 0 - halfwidth, y: 0 )
            let middleRight =   CGPoint(x: width - halfwidth, y: 0  )
            
            //grass2-btm-right-1
            if ( tileData?["sector"] as? UInt32 == 2 && !flipsection ) || ( tileData?["sector"] as? UInt32 == 1 && flipsection )  {
                
                centerTexture = SKTexture(imageNamed: "grass2-btm-right-1")
                tileNode =  SKSpriteNode(texture: centerTexture)
                
                tileNode.position = center
                
                var path = CGMutablePath()
                
                path.addLines(between: [
                    upperLeft, upperRight,
                    centerMost, middleLeft
                    ]
                )
                
                path.closeSubpath()
                
                var physicsBody = SKPhysicsBody(polygonFrom: path)
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: "grass", Attribute: 3)

                // Mark -2
                centerTexture = SKTexture(imageNamed: "grass2-btm-right-2")
                tileNode =  SKSpriteNode(texture: centerTexture)
                tileNode.position = center
                
                path = CGMutablePath()
                
                path.addLines(between: [
                    middleLeft, centerMost,
                    lowerLeft
                    ]
                )
                
                path.closeSubpath()
                physicsBody = SKPhysicsBody(polygonFrom: path)
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: "dirt", Attribute: 6)

                //grass2-btm-right-1
            } else if (tileData?["sector"] as? UInt32 == 1 && !flipsection) || ( tileData?["sector"] as? UInt32 == 2 && flipsection )  {
                
                
                // Mark -1
                centerTexture = SKTexture(imageNamed: "grass2-btmleft-1")
                tileNode =  SKSpriteNode(texture: centerTexture)
                tileNode.position = center
                var path = CGMutablePath()
                
                path.addLines(between: [
                    upperLeft, upperRight,
                    middleRight, centerMost
                    ]
                )
                
                path.closeSubpath()
                
                //let stagename = tileData?["name"] as! String
                var physicsBody = SKPhysicsBody(polygonFrom: path)
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: "grass", Attribute: 3)

                
                // Mark -2
                centerTexture = SKTexture(imageNamed: "grass2-btmleft-2")
                tileNode =  SKSpriteNode(texture: centerTexture)
                tileNode.position = center
                
                path = CGMutablePath()
                
                path.addLines(between: [
                    centerMost, middleRight,
                    lowerRight
                    ]
                )
                
                path.closeSubpath()
                physicsBody = SKPhysicsBody(polygonFrom: path)
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: "dirt", Attribute: 6)

                //grass2-topright
            } else if (tileData?["sector"] as? UInt32 == 4 && !flipsection) || ( tileData?["sector"] as? UInt32 == 3 && flipsection )  {
                
                centerTexture = SKTexture(imageNamed: "grass2-topright-1")
                tileNode =  SKSpriteNode(texture: centerTexture)
                tileNode.position = center
                var path = CGMutablePath()
                path.addLines(between: [
                    upperLeft, centerMost,
                    middleLeft
                    ]
                )
                
                path.closeSubpath()
                var physicsBody = SKPhysicsBody(polygonFrom: path)
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: "grass", Attribute: 6)

                // Mark -2
                centerTexture = SKTexture(imageNamed: "grass2-topright-2")
                tileNode =  SKSpriteNode(texture: centerTexture)
                tileNode.position = center
                
                path = CGMutablePath()
                
                path.addLines(between: [
                    middleLeft, centerMost,
                    lowerRight, lowerLeft
                    ]
                )
                
                path.closeSubpath()
                physicsBody = SKPhysicsBody(polygonFrom: path)
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: "dirt", Attribute: 3)

                //grass2-topleft
            } else if (tileData?["sector"] as? UInt32 == 3 && !flipsection) || ( tileData?["sector"] as? UInt32 == 4 && flipsection )  {
                
                centerTexture = SKTexture(imageNamed: "grass2-topleft-1")
                tileNode =  SKSpriteNode(texture: centerTexture)
                tileNode.position = center
                var path = CGMutablePath()
                
                path.addLines(between: [
                    upperRight,
                    middleRight, centerMost
                    ]
                )
                
                path.closeSubpath()
                
                var physicsBody = SKPhysicsBody(polygonFrom: path)
                
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: "grass", Attribute: 6)

                centerTexture = SKTexture(imageNamed: "grass2-topleft-2")
                tileNode =  SKSpriteNode(texture: centerTexture)
                tileNode.position = center
                
                path = CGMutablePath()
                
                path.addLines(between: [
                    centerMost, middleRight,
                    lowerRight, lowerLeft
                    ]
                )
                
                path.closeSubpath()
                physicsBody = SKPhysicsBody(polygonFrom: path)
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: "dirt", Attribute: 3)
            }
            
            //Check for Cows and Chickens
        } else if ( tileData?["isGrassEnd"] as? Bool == true )  {
            
            let halfwidth = centerTexture.size().width / 2
            let halfheight = centerTexture.size().height / 2
            let width = centerTexture.size().width
            let height = centerTexture.size().height
            
            let upperLeft   =   CGPoint(x: 0 - halfwidth, y: height - halfheight)
            let upperRight  =   CGPoint(x: width - halfwidth, y: height - halfheight)
            let lowerLeft   =   CGPoint(x: 0 - halfwidth , y: 0 - halfheight)
            let lowerRight  =   CGPoint(x: width - halfwidth, y: 0 - halfheight)
            let centerMost  =   CGPoint(x: 0, y: 0 )
            let middleLeft  =   CGPoint(x: 0 - halfwidth, y: 0 )
            let middleRight =   CGPoint(x: width - halfwidth, y: 0  )
            
            //Lower Left Trianglea
            if (tileData?["sector"] as? UInt32) == 2 {
                
                // Mark -1
                centerTexture = SKTexture(imageNamed: name)
                tileNode =  SKSpriteNode(texture: centerTexture)
                
                tileNode.position = center
                
                let path = CGMutablePath()
                
                path.addLines(between: [
                    upperLeft, upperRight,
                    centerMost
                    ]
                )
                
                path.closeSubpath()
                
                let stagename = tileData?["name"] as! String
                let physicsBody = SKPhysicsBody(polygonFrom: path)
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: stagename, Attribute: 6)

                //Lower Right Triangle
            } else if (tileData?["sector"] as? UInt32) == 1 {
                
                // Mark -1
                centerTexture = SKTexture(imageNamed: name)
                tileNode =  SKSpriteNode(texture: centerTexture)
                
                tileNode.position = center
                
                let path = CGMutablePath()
                
                path.addLines(between: [
                    centerMost,
                    lowerLeft, lowerRight
                    ]
                )
                
                path.closeSubpath()
                
                let stagename = tileData?["name"] as! String
                let physicsBody = SKPhysicsBody(polygonFrom: path)
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: stagename, Attribute: 6)

                //Upper Left Triangle
            } else if (tileData?["sector"] as? UInt32) == 4  {
                
                // Mark -1
                centerTexture = SKTexture(imageNamed: name + "-1")
                tileNode =  SKSpriteNode(texture: centerTexture)
                
                tileNode.position = center
                
                var path = CGMutablePath()
                
                path.addLines(between: [
                    upperLeft, middleLeft,
                    centerMost
                    ]
                )
                
                path.closeSubpath()
                
                let stagename = tileData?["name"] as! String
                var physicsBody = SKPhysicsBody(polygonFrom: path)
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: stagename, Attribute: 6)

                // Mark -2
                centerTexture = SKTexture(imageNamed: name + "-2")
                tileNode =  SKSpriteNode(texture: centerTexture)
                tileNode.position = center
                
                path = CGMutablePath()
                
                path.addLines(between: [
                    middleLeft, centerMost,
                    lowerLeft
                    ]
                )
                
                path.closeSubpath()
                physicsBody = SKPhysicsBody(polygonFrom: path)
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: "dirt", Attribute: 6)

                //Upper Right Triangle
            } else if (tileData?["sector"] as? UInt32) == 3  {
                
                // Mark -1
                centerTexture = SKTexture(imageNamed: name + "-1")
                tileNode =  SKSpriteNode(texture: centerTexture)
                
                tileNode.position = center
                
                var path = CGMutablePath()
                
                path.addLines(between: [
                    upperRight, middleRight,
                    centerMost
                    ]
                )
                
                path.closeSubpath()
                var physicsBody = SKPhysicsBody(polygonFrom: path)

                if let stagename = tileData?["name"] as? String {
                    ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: stagename, Attribute: 6)
                }
                
                // Mark -2
                centerTexture = SKTexture(imageNamed: name + "-2")
                tileNode =  SKSpriteNode(texture: centerTexture)
                tileNode.position = center
                
                path = CGMutablePath()
                
                path.addLines(between: [
                    centerMost, middleRight,
                    lowerRight
                    ]
                )
                
                path.closeSubpath()
                physicsBody = SKPhysicsBody(polygonFrom: path)
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: "dirt", Attribute: 6)
            }
        } else if ( tileData?["isCorner"] as? Bool == true )  {
            
            
            
            let halfwidth = centerTexture.size().width / 2
            let halfheight = centerTexture.size().height / 2
            let width = centerTexture.size().width
            let height = centerTexture.size().height
            
            let upperLeft   =   CGPoint(x: 0 - halfwidth, y: height - halfheight)
            let upperRight  =   CGPoint(x: width - halfwidth, y: height - halfheight)
            let lowerLeft   =   CGPoint(x: 0 - halfwidth , y: 0 - halfheight)
            let lowerRight  =   CGPoint(x: width - halfwidth, y: 0 - halfheight)
            
            let path = CGMutablePath()
            
            //Lower Left Triangle
            if (tileData?["sector"] as? UInt32) == 1 {
                
                path.addLines(between: [
                    upperLeft, upperRight,
                    lowerRight,
                    ]
                )
                
                if ( flipsection ) {
                    tileNode.zRotation = CGFloat.pi/2
                }
                
                //Lower Right Triangle
            } else if (tileData?["sector"] as? UInt32) == 2 {
                
                path.addLines(between: [
                    upperLeft, upperRight,
                    lowerLeft,
                    ]
                )
                
                if ( flipsection ) {
                    tileNode.zRotation = -CGFloat.pi/2
                }
                
                //Upper Left Triangle
            } else if (tileData?["sector"] as? UInt32) == 3  {
                
                path.addLines(between: [
                    upperRight,
                    lowerLeft, lowerRight,
                    ]
                )
                
                if ( flipsection ) {
                    tileNode.zRotation = -CGFloat.pi/2
                }
                
                //Upper Right Triangle
            } else if (tileData?["sector"] as? UInt32) == 4  {
                
                path.addLines(between: [
                    upperLeft,
                    lowerLeft, lowerRight,
                    ]
                )
                
                if ( flipsection ) {
                    tileNode.zRotation = CGFloat.pi/2
                }
            }
            
            path.closeSubpath()
            
            let physicsBody = SKPhysicsBody(polygonFrom: path)
            let stagename = tileData?["name"] as! String
            
            if (tileData?["sector"] as? UInt32) == 1 {
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: stagename, Attribute: 4)

                //Lower Right Triangle
            } else if (tileData?["sector"] as? UInt32) == 2 {
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: stagename, Attribute: 4)

                //Upper Left Triangle
            } else if (tileData?["sector"] as? UInt32) == 3  {
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: stagename, Attribute: 4)

                //Upper Right Triangle
            } else if (tileData?["sector"] as? UInt32) == 4  {
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: stagename, Attribute: 4)
            }
            
            
            //Check for Cows and Chickens
        } else if ( tileData?["isEnd"] as? Bool == true )  {
            
            let halfwidth = centerTexture.size().width / 2
            let halfheight = centerTexture.size().height / 2
            
            let width = centerTexture.size().width
            let height = centerTexture.size().height
            
            let upperLeft   =   CGPoint(x: 0 - halfwidth, y: height - halfheight)
            let upperRight  =   CGPoint(x: width - halfwidth, y: height - halfheight)
            let lowerLeft   =   CGPoint(x: 0 - halfwidth , y: 0 - halfheight)
            let lowerRight  =   CGPoint(x: width - halfwidth, y: 0 - halfheight)
            let middle      =   CGPoint(x: 0, y: 0)
            
            let path = CGMutablePath()
            
            //Top Triangle
            if (tileData?["sector"] as? UInt32) == 1 {
                
                path.addLines(between: [
                    middle,
                    lowerLeft, lowerRight
                    ]
                )
                
                //Bottom Triangle
            } else if (tileData?["sector"] as? UInt32) == 2 {
                
                path.addLines(between: [
                    upperLeft, upperRight,
                    middle
                    ]
                )
                
                //Left Triangle
            } else if (tileData?["sector"] as? UInt32) == 3  {
                
                path.addLines(between: [
                    middle,
                    upperRight, lowerRight
                    ]
                )
                
                //Right Triangle
            } else if (tileData?["sector"] as? UInt32) == 4  {
                
                path.addLines(between: [
                    upperLeft,
                    lowerLeft, middle
                    ]
                )
            }
            
            path.closeSubpath()
            
            let physicsBody = SKPhysicsBody(polygonFrom: path)
            let stagename = tileData?["name"] as! String
            
            if (tileData?["sector"] as? UInt32) == 1 {
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: stagename, Attribute: 4)

                //Lower Right Triangle
            } else if (tileData?["sector"] as? UInt32) == 2 {
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: stagename, Attribute: 4)
                //Upper Left Triangle
            } else if (tileData?["sector"] as? UInt32) == 3  {
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: stagename, Attribute: 4)
                //Upper Right Triangle
            } else if (tileData?["sector"] as? UInt32) == 4  {
                ds.DrawSprites(TileNode: tileNode, PhysicsBody: physicsBody, Name: stagename, Attribute: 4)
            }
            // isCoin and isPrize is deprecated, use item integer instead
        } else if newitem.count == 1 && newname.count == 1 && newemoji.count == 1  {
            
            let gravity = true;
            
            let radius = TileMap.tileSize.width / 2.0 - 2.0
            let physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(radius))
            
            //let mysize = CGSize(width: 30, height: 30)
            
            var rotation = true;
            
            let fliph = tileDefinition.flipHorizontally
            let flipy = tileDefinition.flipVertically
            var col = 258 as UInt32
            var con = 32 as UInt32
            var cat = 1024 as UInt32
            
            switch newitem {
                
            case "🐍","🔥","🚧","🚨", "🖲" , "❄️" :
                col = 2 + 128 + 256 + 1024  as UInt32
                con = 1 + 64 as UInt32
                cat = 2 as UInt32
                
            case "👣","🐾","🍞" :
                rotation = false;
                col = 2 + 128 + 256 + 1024  as UInt32
                con = 32 as UInt32
                cat = 1024 as UInt32
            case "☄️" :
                col = 0  as UInt32
                con = 1 + 64 as UInt32
                cat = 16 as UInt32
            case "🐟" :
                rotation = false;
                con = 0 as UInt32
                col = 0  as UInt32
                cat = 512 as UInt32
            case "🌼","📦","😩":
                rotation = true;
                col = 2 + 128 + 256 + 1024 as UInt32
                con = 32 as UInt32
                cat = 1024 as UInt32
                
            case "⭕️": // heroes
                col = 2 + 128 + 256 + 1024 as UInt32
                con = 32 as UInt32
                cat = 1024 as UInt32
                newemoji = String(levelarray[settings.level])
                
            case "❣️", "‼️", "🔱", "💠", "🛡", "🔫":
                col = 2 + 128 + 256 + 1024 as UInt32
                con = 32 as UInt32
                cat = 1024 as UInt32
                
            case "❌": // villains
                col = 2 + 128 + 256 + 1024 as UInt32
                con = 1 + 64 as UInt32
                cat = 2 as UInt32
                newemoji = String(antiarray[settings.level])
                
            // This should work now
            case "💢", "🛑", "♨️"  :
                col = 0 as UInt32
                cat = 0 as UInt32
                con = 0 as UInt32
            case "🦀" :
                col = 1 + 64 as UInt32
                con = 1 + 64 as UInt32
                cat = 8 as UInt32
                
            case "🛸" :
                col = 2 + 64 + 128 + 256 + 1024 as UInt32
                con = 1 + 64 as UInt32
                cat = 2 as UInt32
            default :
                col = 258 as UInt32
                con = 32 as UInt32
                cat = 1024 as UInt32
                
            }
            
            centerTexture = SKTexture()
            tileNode = SKSpriteNode()
            tileNode.position = center
            
            //We cannot apply xScale to sprites with fields on them.
            if newitem != "🎇" && newitem != "💢" &&
                newitem != "♨️" && newitem != "🛑" && leftside {
                tileNode.xScale =  tileNode.xScale * -1
            }

            DrawCoins(TileNode: tileNode, PhysicsBody: physicsBody, Dynamic: true, Gravity: gravity, Category: cat, Collision: col, Rotation: rotation, Emoji: newemoji, Name: newname, Contact: con, Mass: 0.1, Friction: 0, NewItem: newitem, fliph: fliph, flipy: flipy)
        }
    }
}



class DS : TMR {

    
   
    override init(TileMap: SKTileMapNode) {
        super.init(TileMap : TileMap)
    }
    
    
    func DrawSprites(TileNode: SKSpriteNode, PhysicsBody: SKPhysicsBody, Name: String, Attribute: Int) {
        
        TileNode.physicsBody = PhysicsBody
        
        if Name == "dirt" || Name == "land" || Name == "gold" {
            TileNode.physicsBody?.categoryBitMask = 2 as UInt32 //2
            TileNode.physicsBody?.collisionBitMask = 2 + 128 as UInt32  //2
            TileNode.physicsBody?.contactTestBitMask = 0 as UInt32
        } else if Name == "stone" {
            TileNode.physicsBody?.categoryBitMask = 2 as UInt32 //2
            TileNode.physicsBody?.collisionBitMask = 2 + 128 as UInt32  //2
            TileNode.physicsBody?.contactTestBitMask = 0 as UInt32
        } else {
            TileNode.physicsBody?.categoryBitMask = 256 //2
            TileNode.physicsBody?.collisionBitMask = 258 + 128 //2
            TileNode.physicsBody?.contactTestBitMask = 0
        }
        
        //small stuff gets blasted
        //if ( Attribute == 6 ) {
        //   TileNode.physicsBody?.isDynamic = true //false
        //    TileNode.physicsBody?.affectedByGravity = false //true
        
        //} else {
        TileNode.physicsBody?.isDynamic = false //false
        TileNode.physicsBody?.affectedByGravity = true //true
        //}
        
        TileNode.physicsBody?.fieldBitMask =  0
        TileNode.physicsBody?.allowsRotation = true //true
        TileNode.physicsBody?.pinned = false  //false
        TileNode.physicsBody?.restitution = 0.1 * CGFloat(Attribute)
        TileNode.physicsBody?.isResting = true
        TileNode.physicsBody?.friction = 0.0
        TileNode.physicsBody?.mass = 1
        TileNode.physicsBody?.density = 0.1 * CGFloat(Attribute)
        TileNode.zPosition = 70
        TileNode.name = Name
        
        TileMap.parent?.addChild(TileNode)
        
    }
}

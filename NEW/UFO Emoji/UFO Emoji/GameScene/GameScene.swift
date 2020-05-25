 //
 //  GameScene.swift
 //  UF Emoji
 //
 //  Created by Todd Bruss on 12/3/15 to 5/9/20
 //  Copyright (c) 2015 Todd Bruss. All rights reserved.
 //
 
 import SpriteKit
 import AVFoundation
 
 class GameScene: SKScene, ThumbPadProtocol, SKPhysicsContactDelegate, AVAudioPlayerDelegate {
    
    deinit {
        backParalax.removeFromParent()
        
        world?.removeAllActions()
        world?.removeAllChildren()
        world?.removeFromParent()
        
        cam.removeAllActions()
        cam.removeAllChildren()
        cam.removeFromParent()
        
        camera?.removeFromParent()
        camera?.removeAllActions()
        camera?.removeFromParent()
         
        removeAllActions()
        removeAllChildren()
        removeFromParent()
    }
    
    weak var firstBody : SKPhysicsBody!
    weak var secondBody : SKPhysicsBody!
    var rockBounds = CGRect()
    var screenHeight = CGFloat()
    var cam = SKCameraNode()
    var moving = SKNode()
    var audioPlayer: AVAudioPlayer?
    var world:SKNode?
    let ThumbPad: JoyPad = JoyPad()
    var bombsbutton: SKSpriteNode? = nil
    var firebutton: SKSpriteNode? = nil
    var bombsbutton2: SKSpriteNode? = nil
    var firebutton2: SKSpriteNode? = nil
    var hero:SKSpriteNode!
    var heroEmoji:SKLabelNode!
    var canape:SKSpriteNode!
    var tractor:SKSpriteNode!
    var centerTexture: SKTexture!
    var scoreLabelNode:SKLabelNode!
    var highScoreLabelNode:SKLabelNode!
    var hud: SKNode!
    var highScoreLabel:SKLabelNode!
    var livesLabel:SKLabelNode!
    var livesLabelNode:SKLabelNode!
    var heroLocation:CGPoint = CGPoint.zero
    weak var TileMap: SKTileMapNode!
    var rockPile:SKNode = SKNode()
    var score = Int()
    var level = Int()
    var highscore = Int()
    var lives = Int()
    var highlevel = Int()
    let heroCategory:UInt32         =  1
    let worldCategory:UInt32        =  2
    let bombBoundsCategory:UInt32   =  4
    let badFishCategory:UInt32      =  8
    let badGuyCategory:UInt32       =  16
    let tractorCategory:UInt32      =  32
    let laserbeam: UInt32           =  64
    let wallCategory:UInt32         =  128
    let itemCategory:UInt32         =  256
    let fishCategory:UInt32         =  512
    let charmsCategory:UInt32       =  1024
    let levelupCategory:UInt32      =  2048
    let laserBorder:UInt32          =  4096
    var scoreDict: [String:Int] = [:]
    
    var laserbeak = GameProjectiles(laserbeak: nil,🚞: nil)
    //we can swap these out if we use other emoji ships: 0 through 6

    
    func readyPlayerOne () -> Oreo? {
        
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
        
        
        func drawSpriteII(texture: String, name: String, category:UInt32, collision:UInt32, contact:UInt32, field:UInt32, dynamic:Bool, allowRotation:Bool, affectedGravity:Bool, zPosition:CGFloat, alpha:CGFloat, speed:CGFloat, alphaThreshold: Float) -> SKSpriteNode?  {
            
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
                sprite.position = CGPoint(x:sprite.position.x, y: sprite.position.y - 25)
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
            addChild(sprite)
            sprite.texture?.preload {
            }
            
            
            return sprite
        }
        
        
        
        func drawHudII( texture: String, name: String, category:UInt32, collision:UInt32, contact:UInt32, field:UInt32, dynamic:Bool, allowRotation:Bool, affectedGravity:Bool, zPosition:CGFloat, alpha:CGFloat, speed:CGFloat, alphaThreshold: Float) -> SKSpriteNode? {
            
            let sprite = SKSpriteNode(imageNamed: texture)
            let btnLoc = settings.stick ? "R" : "L"
            
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
            
            headsUpDisplay.addChild(sprite)
            
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
                    x: CGFloat(frame.size.width / -2 + (85 * xAdjust) ) ,
                    y: CGFloat(frame.size.height / -2 + (85 * yAdjust ) )
                )
            } else {
                headsUpDisplay.position = CGPoint(
                    x: CGFloat(frame.size.width / 2 - (85 * xAdjust)  ) ,
                    y: CGFloat(frame.size.height / -2 + (85 * yAdjust ) )
                )
            }
            
            if settings.mode == 1 {
                
                if btnLoc == "L" {
                    headsUpDisplay.position = CGPoint(x: CGFloat(frame.size.width / -2 + (87 * 0.75) ) ,y:  CGFloat(frame.size.height / -2 + (87 * 0.75)) )
                } else {
                    headsUpDisplay.position = CGPoint(x: CGFloat(frame.size.width / 2 - (87 * 0.75) ) ,y:  CGFloat(frame.size.height / -2 + (87 * 0.75)) )
                }
                
                headsUpDisplay.setScale(0.75)
                
            }
            
            return sprite
            
        }
        
        
        //drawsprites
        hero = drawSpriteII (
            texture: rocket,
            name: "hero",
            category: heroCategory,
            collision: wallCategory,
            contact: worldCategory + levelupCategory,
            field: 1,
            dynamic: true,
            allowRotation: false,
            affectedGravity: false,
            zPosition: 15000,
            alpha: 1.0,
            speed: 1,
            alphaThreshold: 0.0
        )
        
        heroEmoji = SKLabelNode(fontNamed:"Apple Color Emoji")
        heroEmoji.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        heroEmoji.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        heroEmoji.alpha = 1.0
        heroEmoji.position = CGPoint(x: 0, y: offset)
        heroEmoji.fontSize = CGFloat(size)
        heroEmoji.zPosition = 24
        heroEmoji.text = heroArray[settings.emoji]
        hero.addChild(heroEmoji)
        
        canape = drawSpriteII (
            texture: glass,
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
        )
        
        
        
        tractor = drawSpriteII (
            texture: "tractorbeam",
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
        )
        
        _ = drawHudII (
            texture: "hud45-right",
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
        )
        
        _ = drawHudII (
            texture: "hud45-left",
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
        )
        
        _ = drawHudII (
            texture: "hud45-btm",
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
        )
        
        _ = drawHudII (
            texture: "hud45-top",
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
        )
        
        firebutton = drawHudII (
            texture: "fire45-right",
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
        )
        
        firebutton2 = drawHudII (
            texture: "fire45-left",
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
        )
        
        bombsbutton2 = drawHudII (
            texture: "fire45-top",
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
        )
        
        bombsbutton = drawHudII (
            texture: "fire45-btm",
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
        )
        
        
        func createHeroJoint() {
            
            
            let bodyA = hero.physicsBody!
            let bodyB = tractor.physicsBody!
            bodyA.density = 1.0
            let joint = SKPhysicsJointPin.joint(withBodyA: bodyA,  bodyB:bodyB, anchor: hero.position)
            physicsWorld.add(joint)
        }
        
        func createCanapeJoint() {
            
            
            let bodyA = hero.physicsBody!
            let bodyB = canape.physicsBody!
            let joint = SKPhysicsJointPin.joint(withBodyA: bodyA,  bodyB:bodyB, anchor: hero.position)
            joint.rotationSpeed = 1.0
            physicsWorld.add(joint)
        }
        
        func arcadeJoyPad() {
            
            
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
                    x: CGFloat(frame.size.width / -2 + (85 * xAdjust) ) ,
                    y: CGFloat(frame.size.height / -2 + (85 * yAdjust ) )
                )
            } else {
                ThumbPad.position = CGPoint(
                    x: CGFloat(frame.size.width / 2 - (85 * xAdjust)  ) ,
                    y: CGFloat(frame.size.height / -2 + (85 * yAdjust ) )
                )
            }
            
            ThumbPad.delegate = self
            camera?.addChild(ThumbPad)
            ThumbPad.zPosition = 1000
            ThumbPad.name = "ArcadeJoyPad"
            
            if settings.mode == 1 {
                ThumbPad.setScale(0.75)
                
                if stick == "L" {
                    ThumbPad.position = CGPoint(x: CGFloat(frame.size.width / -2 + (87 * 0.75) ) ,y:  CGFloat(frame.size.height / -2 + (87 * 0.75)) )
                } else {
                    ThumbPad.position = CGPoint(x: CGFloat(frame.size.width / 2 - (87 * 0.75) ) ,y:  CGFloat(frame.size.height / -2 + (87 * 0.75)) )
                }
            }
        }
        
        
        
        createCanapeJoint()
        createHeroJoint()
        arcadeJoyPad()
        
        return (bombsbutton,firebutton,hero,canape,tractor,bombsbutton2,firebutton2)
    }
    
    
    
    func setupLevel(tileMap: SKTileMapNode) {
        let tmr = TMRX(TileMap: tileMap)
        	tileMap.alpha = 0.0
            for col in (0 ..< tileMap.numberOfColumns) {
                for row in (0 ..< tileMap.numberOfRows) {
                    let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row)
                    let center = tileMap.centerOfTile(atColumn: col, row: row)
                    tileDefinition?.textures.removeAll()
                    tileDefinition?.normalTextures.removeAll()

                    if let td = tileDefinition, let n = td.name, !n.isEmpty {
                        tmr.tileMapRun(tileDefinition: td, center: center)
                    }
                    
                }
            }
            
            tileMap.removeAllChildren()
            tileMap.removeFromParent()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(hero.position.y > screenHeight  ) {
            highScoreLabelNode.run(SKAction.fadeAlpha(to: 0.0, duration: 0.25))
            highScoreLabel.run(SKAction.fadeAlpha(to: 0.0, duration: 0.25))
        } else if (highScoreLabelNode.alpha < 0.4) {
            highScoreLabelNode.run(SKAction.fadeAlpha(to: 0.4, duration: 0.25))
            highScoreLabel.run(SKAction.fadeAlpha(to: 0.4, duration: 0.25))
        }
    }
    
    
    func demoMode() {
        /* demo mode */
        shield = true
        🔋 = true
        🔱 = true
        let logonode = SKSpriteNode(texture: SKTexture(imageNamed: "UFOEmojiLogoLarge"))
        self.camera?.addChild(logonode)
        logonode.setScale(0.1875)
        logonode.alpha = 1.00
        logonode.zPosition = 100
        hero.zPosition = 1000
        hero.setScale(1.75)
        tractor.setScale(1.75)
        canape.setScale(1.75)
        /* end demo mode */
    }
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        
        
        
        
        laserbeak = GameProjectiles(laserbeak: laserbeam, 🚞: self)
        
        world = childNode(withName: "world")
        
        // This is the default of King, Queen Nationality
        KingQueenGlobalDie = 100
        
        🔱 = false
        🔋 = false
        shield = false
        
        doublelaser = 0
        
        if (settings.level >= 1 && settings.level <= 10) {
            if let soundURL: URL = Bundle.main.url(forResource: "music1", withExtension: "mp3") {
                audioPlayer = try? AVAudioPlayer(contentsOf: soundURL)
            }
        }
        
        if settings.music {
            audioPlayer?.numberOfLoops = 0
            audioPlayer?.stop()
            audioPlayer?.volume = 0.0
        }
        
        cam = SKCameraNode()
        camera = cam
        addChild(cam)
        cam.zPosition = 100
        
        headsUpDisplay.name = "HeadsUpDisplay"
        cam.addChild(headsUpDisplay)
        headsUpDisplay.zRotation = CGFloat(Double.pi/4)
        
        guard let gamestartup = readyPlayerOne() else { return }
        
        doublelaser = 0;
        scoreDict[""] = 0
        scoreDict["🐽"] = 5
        scoreDict["🌸"] = 10
        scoreDict["🥛"] = 15
        scoreDict["🎁"] = 20
        scoreDict["🤠"] = 25
        scoreDict["🔥"] = 30
        scoreDict["🐝"] = 35
        scoreDict["🚔"] = 40
        scoreDict["🏢"] = 45
        scoreDict["👤"] = 50
        scoreDict["🖲"] = 55
        scoreDict["😰"] = 60 //super villians
        scoreDict["😨"] = 70 //super villians
        scoreDict["⭕️"] = 75 //heroes
        scoreDict["❌"] = 75 //villians
        scoreDict["😱"] = 80 //super villians
        scoreDict["😳"] = 90 //super villians
        scoreDict["🤯"] = 100 //super villian leader
        scoreDict["💎"] = 110 //rare
        scoreDict["👑"] = 115 //rare
        scoreDict["❣️"] = 120 //extra life (displays him/herself in the game)
        scoreDict["🔫"] = 130 //super rare marker for double laser beams
        scoreDict["🔱"] = 140 //super rare trident (super bomb)
        scoreDict["‼️"] = 130 //super rare shields (cloaked ghost, move through walls)
        scoreDict["🛡"] = 150 //super rare shields (cloaked ghost, move through walls)
        scoreDict["💠"] = 150 //super rare shields (cloaked ghost, move through walls)
        scoreDict["gold"] 	= 16
        scoreDict["land"] 	= 1
        scoreDict["dirt"] 	= 1
        scoreDict["grass"] 	= 2
        scoreDict["desert"] = 2
        scoreDict["sand"] 	= 4
        scoreDict["stone"] 	= 8
        
        hero = gamestartup.hero
        canape = gamestartup.canape
        tractor = gamestartup.tractor
        tractor.addGlow()
        
    	bombsbutton = gamestartup.bombsbutton
        firebutton = gamestartup.firebutton
        bombsbutton2 = gamestartup.bombsbutton2
        firebutton2 = gamestartup.firebutton2
        
        (level, highlevel, score, highscore, lives) = GameStartup.gs.loadScores()
        
        
        var background = ""
        
        switch level {
            
            //skyMtns
            case 1..<100:
                background = "waterWorld"
            case 6..<9:
                ()
            case 10:
                ()
            default :
                ()
        }
        
        
        var filename = "" //default
        
        filename = "level1"
        
        //Check if level exists first (safe)
        if let section = SKReferenceNode(fileNamed: filename)  {
            addChild(section)
            section.position = CGPoint(x:0,y:0)
            
            //self.isPaused = true
            
            if let level = section.children.first?.children {
                //No longer hard encoded
                for land in level {
                    
                    if let name = land.name {
                        if let midsection = section.childNode(withName: "//" + name ) as? SKTileMapNode {
                            
                            if name != "Water" {
                                self.setupLevel( tileMap: midsection)
                            } else {
                                self.removeFromParent()
                                land.alpha = 0.4
                                land.zPosition = 1000
                            }
                        }
                    }
                }
            }
            
            //self.isPaused = false
            
        } else {
            print("//*** Level not found: \(filename) ***//")
        }
                
        for node in self.children {
            if (node.name == "world") {
                
                //Texture Map Node Stuff goes here
                for node in node.children {
                    
                    if(node.name == "Rocky") {
                        node.zPosition = 50
                        rockBounds = node.frame
                        
                        
                        scene?.physicsWorld.gravity = CGVector(dx: 0.0, dy: -3) //mini
                        scene?.physicsWorld.contactDelegate = self
                        node.physicsBody = SKPhysicsBody(edgeLoopFrom: rockBounds)
                        
                        node.physicsBody?.categoryBitMask = wallCategory //2 + 8 + 128 + 256 + 512 + 1024
                        node.physicsBody?.collisionBitMask = 0
                        node.physicsBody?.restitution = 0.02
                        node.physicsBody?.contactTestBitMask = 0
                        
                        //container for bombBounds
                        let bombBounds = CGRect(x: node.frame.origin.x ,y: node.frame.origin.y, width: node.frame.width, height: node.frame.height + 128)
                        
                        let addnode = SKNode()
                        addnode.name = "bombBounds"
                        addnode.zPosition = -10000
                        
                        addnode.physicsBody = SKPhysicsBody(edgeLoopFrom: bombBounds)
                        addnode.physicsBody?.categoryBitMask = bombBoundsCategory;
                        addChild(addnode)
                        
                        let node = SKNode()
                        
                        if  let x = scene?.frame.origin.x,
                            let y = scene?.frame.origin.y,
                            let w = scene?.frame.width,
                            let h = scene?.frame.height {
                            
                            let laserBounds = CGRect(x: x - 5, y: y, width: w + 10, height: h)
                            node.physicsBody = SKPhysicsBody(edgeLoopFrom: laserBounds )
                        }
                        
                        node.name = "🔲"
                        node.physicsBody?.categoryBitMask = laserBorder
                        node.physicsBody?.collisionBitMask = 0
                        node.physicsBody?.contactTestBitMask = 0
                        node.physicsBody?.isDynamic = false
                        node.physicsBody?.affectedByGravity = false
                        node.physicsBody?.restitution = 0
                        node.speed = 0
                        node.yScale = 1.5
                        self.camera?.addChild(node)
                    }
                }
            }
        }
    
        world?.addChild(moving)
        
        backParalax.removeFromParent()
        self.world?.addChild(backParalax)
        
        let texture = SKTexture(imageNamed: background)
        texture.filteringMode = .linear
        texture.preload { [weak self] in
            guard
                let self = self
                
                else { return }
            let rounded = Int(round( self.rockBounds.width / 1440 / 2 ))
            var sprite = SKSpriteNode(texture: texture)
            sprite.name = String("BackTexture")
            sprite.xScale = 4
            sprite.yScale = 4
            
            for i in -rounded...rounded  {
                sprite.position = CGPoint(x: CGFloat(i) * 1440, y: 0)
                backParalax.addChild(sprite.copy() as! SKSpriteNode )
            }
            
            backParalax.zPosition = -243
            sprite = SKSpriteNode()
            
            backParalax.name = "backParalaxOriginal"
            backParalax = backParalax.copy() as! SKNode
            self.world?.addChild(backParalax)
            
        }
            
        world?.speed = 0
        moving.speed = 1
        
        if settings.emoji == 2 {
            emojiAnimation(emojis:["🙈","🙊","🙉","🐵"])
        }
        
        var sceneheight = CGFloat(0)
        var indent = CGFloat(0)
        
        if let sh = scene?.frame.size.height, let sw = scene?.frame.size.width {
            screenHeight = sh / 2 - 64
            sceneheight = sh / 2
            indent = ( sw / 2 ) - 7.5 * CGFloat(settings.mode)
        }
        
        let difference = CGFloat(20)
        let labelheight = sceneheight - difference
        let scoreheight = sceneheight - (difference * CGFloat(2))
        let scoreLabel = SKLabelNode(fontNamed:"Emulogic")
        scoreLabel.position = CGPoint( x: -indent, y: labelheight )
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.alpha = 0.4
        scoreLabel.zPosition = 100
        scoreLabel.text = String("🎲")
        scoreLabel.fontSize = 14
        cam.addChild(scoreLabel)
        
        scoreLabelNode = SKLabelNode(fontNamed:"Emulogic")
        scoreLabelNode.position = CGPoint( x: -indent, y: scoreheight  )
        scoreLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabelNode.alpha = 0.4
        scoreLabelNode.zPosition = 100
        scoreLabelNode.text = String(score)
        scoreLabelNode.fontSize = 14
        cam.addChild(scoreLabelNode)
        
        /* High Score */
        highScoreLabel = SKLabelNode(fontNamed:"Emulogic")
        highScoreLabel.position = CGPoint( x: 0, y: labelheight )
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        highScoreLabel.alpha = 0.4
        highScoreLabel.zPosition = 100
        highScoreLabel.text = String("💎")
        highScoreLabel.fontSize = 14
        highScoreLabel.name = "highScoreLabel"
        cam.addChild(highScoreLabel)
        
        highScoreLabelNode = SKLabelNode(fontNamed:"Emulogic")
        highScoreLabelNode.position = CGPoint( x: 0, y: scoreheight )
        highScoreLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        highScoreLabelNode.alpha = 0.4
        highScoreLabelNode.zPosition = 100
        highScoreLabelNode.text = String(highscore)
        highScoreLabelNode.fontSize = 14
        highScoreLabelNode.name = "highScoreLabelNode"
        cam.addChild(highScoreLabelNode)
        
        livesLabel = SKLabelNode(fontNamed:"Emulogic")
        livesLabel.position = CGPoint( x: indent, y: labelheight )
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.alpha = 0.4
        livesLabel.zPosition = 100
        livesLabel.text = String("💛")
        livesLabel.fontSize = 14
        cam.addChild(livesLabel)
        
        livesLabelNode = SKLabelNode(fontNamed:"Emulogic")
        livesLabelNode.position = CGPoint( x: indent, y: scoreheight )
        livesLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabelNode.alpha = 0.4
        livesLabelNode.zPosition = 100
        livesLabelNode.text = String(livesDisplay[lives])
        livesLabelNode.fontSize = 14
        cam.addChild(livesLabelNode)
        
        if settings.music {
            self.audioPlayer?.numberOfLoops = -1
            self.audioPlayer?.play()
            self.audioPlayer?.volume = 1.0
        } else {
            self.audioPlayer?.numberOfLoops = 0
            self.audioPlayer?.stop()
            self.audioPlayer?.volume = 0.0
        }
    }
    
    override func didSimulatePhysics() {
        
        guard
            let h = hero,
            let c = canape
            else
        { return }
        
        //camera node x position = hero's
        cam.position.x = h.position.x
        
        //canape and hero have the same rotation
        c.zRotation = h.zRotation
        
        // adds depth to the scene
        // by moving the backgorund slower
        backParalax.position.x = cam.position.x * 0.334
    }
    
    
    public func emojiAnimation(emojis:Array<String>) {
        
        guard let emojiLab = hero.children[0] as? SKLabelNode else { return }
        
        let runemoji = (SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.run() {
                emojiLab.text = emojis[0]
            },
            SKAction.wait(forDuration: 1.0),
            SKAction.run() {
                emojiLab.text = emojis[1]
            },
            SKAction.wait(forDuration: 1.0),
            SKAction.run() {
                emojiLab.text = emojis[2]
            },
            SKAction.wait(forDuration: 1.0),
            SKAction.run() {
                emojiLab.text = emojis[3]
            }
            
        ]))
        
        run(SKAction.repeatForever(runemoji))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            let firebutton = firebutton,
            let firebutton2 = firebutton2,

            let bombsbutton = bombsbutton,
            let bombsbutton2 = bombsbutton2,
            let heroVelocity = hero.physicsBody?.velocity
            else
        { return }
        
        super.touchesBegan(touches as Set<UITouch>, with: event)
        
        for touch: AnyObject in touches {
            let location: CGPoint = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if let name = touchedNode.name {
                
                if name == "fire-right" {
                    laserbeak.hero(hero: (hero.position, hero.zRotation, heroVelocity), reverse:false)
                    laserbeak.firebomb(firebomb: firebutton)
                }
                
                if name == "fire-left" {
                    laserbeak.hero(hero: (hero.position, hero.zRotation, heroVelocity), reverse:true)
                    laserbeak.firebomb(firebomb: firebutton2)
                }
                
                if name == "fire-down" {
                    GameProjectiles(bombsaway: laserbeam, 🚞: self, hero: (hero.position, hero.zRotation, heroVelocity), reverse: false).firebomb(firebomb: bombsbutton)
                }
                
                if name == "fire-top" {
                    GameProjectiles(bombsaway: laserbeam, 🚞: self, hero: (hero.position, hero.zRotation, heroVelocity), reverse:true ).firebomb(firebomb: bombsbutton2)
                }
            }
        }
    }
    
    
    //To Do: Move this to GameHits
    func tractorBeamedThisItem(prize:SKSpriteNode) {
        //update score
        
        if prize.physicsBody == nil && prize.name == nil && prize.name == "🌠" {
            return
        }
        // send the collisions to neverLand
        // this way the score cannot be counted twice or more
        // any prize or coin can get sucked up
        prize.physicsBody?.contactTestBitMask = 0
        prize.physicsBody?.categoryBitMask = 0 // wil disable contact
        prize.physicsBody?.collisionBitMask = 0
        prize.physicsBody?.isResting = true
        prize.physicsBody?.isDynamic = false
        prize.physicsBody?.mass = 1
        prize.speed = 0.5
        
        let move = SKAction.moveBy(x: 0, y: 48, duration: 0.2)
        let fade = SKAction.fadeOut(withDuration: TimeInterval(0.2))
        let scale = SKAction.scale(to: 0.25, duration:TimeInterval(0.2))
        
        let extraPoints = tallyPoints(name: prize.name!)
        updateScore(extraPoints:extraPoints * 2)
        prize.name = "🌠"; // will disable contact
        let removeFromParent = SKAction.removeFromParent()
        prize.physicsBody?.isDynamic = false
        prize.run(SKAction.sequence([move]))
        prize.run(SKAction.sequence([fade]))
        prize.run(SKAction.sequence([scale,removeFromParent]))
    }
    
    //MARK: For troubleshooting max velocity - test flying to the right
    /*let localMaxVelocity = CGFloat(max(pb.velocity.dx, pb.velocity.dy))
     
     if localMaxVelocity > maxVelocity {
     maxVelocity = localMaxVelocity
     print("max:",maxVelocity)
     }*/
    //MARK: End troubleshooting
    
    let zero = CGFloat(0.0), dampZero = CGFloat(0.0), dampMax = CGFloat(40.0)
    let ease = TimeInterval(0.08), shipduration = TimeInterval(0.005)
    let shipMax = CGFloat(500.0)
    let shipCtr = CGFloat(250.0)
    let shipMin = CGFloat(-500.0)
    
    
    func TouchPad(velocity: CGVector, zRotation: CGFloat) {
        
        //MARK: reference to hero's physic's body - easier
        guard let pb = hero.physicsBody else { return }
        
        func rotateShip (_ t: TimeInterval, _ angle: CGFloat ) {
            let rot = SKAction.rotate(toAngle: angle, duration: t)
            rot.timingMode = .easeInEaseOut
            hero.run(rot)
        }
        
        if velocity == CGVector.zero {
            
            pb.linearDamping = dampMax
            pb.velocity = velocity
            
            rotateShip(ease, zRotation)
        } else {
            
            pb.linearDamping = CGFloat(dampZero)
            pb.velocity = velocity
            
            //MARK: Clamp using min max
            func clamp (_ f: CGFloat) -> CGFloat {
                min(max(f, shipMin), shipMax)
            }
            
            //MARK: Add a little extra to our ships movement
            pb.applyImpulse(CGVector( dx: velocity.dx / shipCtr, dy: velocity.dy / shipMax))
            
            //MARK: make sure we don't exceed 500 - Impulse is an accelerant
            pb.velocity.dx = clamp(pb.velocity.dx)
            pb.velocity.dy = clamp(pb.velocity.dy)
            
            rotateShip(shipduration, zRotation)
        }
    }
    
    
    
    
    func blueZ (pos: CGPoint) {
        
        if let smoke = SKEmitterNode(fileNamed: "blueParticle") {
            let fadeToZero = SKAction.fadeAlpha(to: 0.0, duration:TimeInterval(2.0))
            let removeFromParent = SKAction.removeFromParent()
            let destroyVaporDelay = SKAction.wait(forDuration: 2.0)
            smoke.run(SKAction.sequence([destroyVaporDelay,fadeToZero,removeFromParent]))
            smoke.position = pos
            smoke.alpha = 0.5
            
            smoke.speed = 5
            smoke.zPosition = 150
            addChild(smoke)
        }
        
        
        if settings.sound {
            let explosion: SKAction = SKAction.playSoundFileNamed("murrmurr.m4a", waitForCompletion: false)
            run(explosion)
        }
    }
    
    
    func smokeM (pos: CGPoint) {
        
        if let smoke = SKEmitterNode(fileNamed: "smokeParticle") {
            let fadeToZero = SKAction.fadeAlpha(to: 0.0, duration:TimeInterval(2.0))
            let removeFromParent = SKAction.removeFromParent()
            let destroyVaporDelay = SKAction.wait(forDuration: 2.0)
            smoke.run(SKAction.sequence([destroyVaporDelay,fadeToZero,removeFromParent]))
            smoke.position = pos
            smoke.speed = 5
            smoke.zPosition = 150
            addChild(smoke)
        }
        
        if settings.sound {
            let explosion: SKAction = SKAction.playSoundFileNamed("boomFire2.m4a", waitForCompletion: false)
            run(explosion)
        }
    }
    
    func magicParticle (pos: CGPoint) {
        
        guard let smoke = SKEmitterNode(fileNamed: "magicParticle") else { return }
        
        let fadeToZero = SKAction.fadeAlpha(to: 0.0, duration:TimeInterval(2.0))
        let removeFromParent = SKAction.removeFromParent()
        let destroyVaporDelay = SKAction.wait(forDuration: 2.0)
        smoke.run(SKAction.sequence([destroyVaporDelay,fadeToZero,removeFromParent]))
        smoke.position = pos
        smoke.speed = 5
        smoke.zPosition = 150
        addChild(smoke)
        
        if settings.sound {
            let explosion: SKAction = SKAction.playSoundFileNamed("boomFire2.m4a", waitForCompletion: false)
            run(explosion)
        }
    }
    
    
    func stoneVersusLaser(firstBody: SKPhysicsBody, secondBody: SKPhysicsBody, contactPoint: CGPoint ) {
        if ( secondBody.node == nil )  {
            return
        } else {
            blueZ(pos:contactPoint)
            remove(body:secondBody)
        }
    }
    
    
    func worldVersusLaser(firstBody: SKPhysicsBody, secondBody: SKPhysicsBody, contactPoint: CGPoint ) {
        
        if ( firstBody.node?.parent != nil && secondBody.node?.parent != nil && firstBody.node != nil && secondBody.node != nil )  {
            let firstBodyPos = firstBody.node?.scene?.convert((firstBody.node?.position)!, from: (firstBody.node?.parent)!)
            let secondBodyPos = secondBody.node?.scene?.convert((secondBody.node?.position)!, from: (secondBody.node?.parent)!)
            
            if firstBody.node != nil {
                firstBody.isDynamic = true
                
                var dampening = CGFloat(50.0) // was 52
                
                if level == 50000 {
                    dampening = 5
                    firstBody.affectedByGravity = true
                }
                
                firstBody.linearDamping = dampening
                
                let x1 = firstBodyPos?.x
                let x2 = hero.position.x
                
                let y1 = firstBodyPos?.y
                let y2 = secondBodyPos?.y
                
                var pos = CGFloat(-1)
                if Double(x1!) > Double(x2) {
                    pos = CGFloat(1)
                } else if Double(x1!) == Double(x2){
                    pos = 0
                }
                
                var turn = CGFloat(-1)
                if Double(y1!) > Double(y2!) {
                    turn = CGFloat(1)
                } else if Double(y1!) == Double(y2!){
                    turn = 0
                }
                
                if settings.level == 50000 {
                    firstBody.applyImpulse(CGVector(dx: 5 * pos, dy: 5 * turn))
                } else {
                    firstBody.applyImpulse(CGVector(dx: 10 * pos, dy: 0))
                }
                
                firstBody.angularVelocity = 15 * pos * turn
                firstBody.applyTorque(3 * -pos * turn)
                
                
                remove(body:secondBody)
            }
            
        }
        
        
    }
    func laserVersusFloater(firstBody:SKPhysicsBody,secondBody:SKPhysicsBody, contactPoint: CGPoint) {
        
        
        if ( secondBody.node?.parent != nil && firstBody.node?.parent != nil && secondBody.node != nil && firstBody.node != nil) {
            
            let firstBodyPos = secondBody.node?.scene?.convert((secondBody.node?.position)!, from: (secondBody.node?.parent)!)
            let secondBodyPos = firstBody.node?.scene?.convert((firstBody.node?.position)!, from: (firstBody.node?.parent)!)
            
            if secondBody.node != nil {
                secondBody.isDynamic = true
                //secondBody.node?.zPosition = 100;
                
                secondBody.linearDamping = 50
                secondBody.node?.setScale(1.15)
                
                let x1 = firstBodyPos?.x
                let x2 = hero.position.x
                
                let y1 = firstBodyPos?.y
                let y2 = secondBodyPos?.y
                
                var pos = CGFloat(-1)
                if Double(x1!) > Double(x2) {
                    pos = CGFloat(1)
                } else if Double(x1!) == Double(x2){
                    pos = 0
                }
                
                var turn = CGFloat(-1)
                if Double(y1!) > Double(y2!) {
                    turn = CGFloat(1)
                } else if Double(y1!) == Double(y2!){
                    turn = 0
                }
                
                secondBody.applyImpulse(CGVector(dx: 10 * pos, dy: 0))
                secondBody.angularVelocity = 15 * pos * turn
                secondBody.applyTorque(3 * -pos * turn)
                remove(body:firstBody)
            }
        }
    }
    
    func baddiePointsHelper(firstBody:SKPhysicsBody, secondBody:SKPhysicsBody, contactPoint: CGPoint) {
        if (firstBody.node?.name != nil) {
            let extraPoints = tallyPoints(name: (firstBody.node?.name)!)
            updateScore(extraPoints:extraPoints )
            smokeM(pos: contactPoint)
            remove(body:firstBody)
            remove(body:secondBody)
        }
    }
    
    
    
    func remove(body:SKPhysicsBody?) {
        guard
            let b = body,
            let node = b.node as? SKSpriteNode
            else { return }
        
        node.run( SKAction.removeFromParent() )
    }
    
    // Here we are super careful not cause a crash
    func removeNode(node:SKSpriteNode?) {
        guard let n = node else { return }
        
        let r = SKAction.removeFromParent()
        n.run(r)
    }
    
    
    func goodiePointsHelper(firstBody:SKPhysicsBody, secondBody:SKPhysicsBody, contactPoint: CGPoint) {
        guard let sbnn = secondBody.node?.name else { return }
        
        let extraPoints = tallyPoints(name: (sbnn))
        updateScore(extraPoints:extraPoints )
        magicParticle(pos: contactPoint)
        remove(body: firstBody)
        remove(body: secondBody)
    }
    
    
    func levelUpHelper() {
        level += 1
        
        if highlevel > maxlevel {
            highlevel = maxlevel
        }
        
        if level > highlevel {
            highlevel = level
        }
        
        if level > maxlevel {
            level = 1
        }
        
        moving.speed = 0
        tractor.speed = 0
        
        
        if settings.music {
            audioPlayer?.numberOfLoops = 0
            audioPlayer?.stop()
            audioPlayer?.volume = 0.0
        }
    }
    
    
    
    //MARK: digBeginContact
    func didBegin(_ contact: SKPhysicsContact) {
        guard
            contact.bodyA.categoryBitMask !=  0,
            contact.bodyB.categoryBitMask != 0,
            contact.bodyA.node?.parent != nil,
            contact.bodyB.node?.parent != nil,
            contact.bodyA.node != nil,
            contact.bodyB.node != nil,
            contact.bodyA.node?.name != nil,
            contact.bodyB.node?.name != nil
            else { return }
        
        
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            secondBody = contact.bodyA
            firstBody = contact.bodyB
        }
        
        let catMask = firstBody.categoryBitMask | secondBody.categoryBitMask
        
        switch catMask {
            
            case laserbeam | laserBorder :
                if let x = firstBody.node?.name {
                    if x == "🚩" {
                        remove(body:firstBody)
                    }
            }
            
            case worldCategory | laserbeam :
                //take care of business
                
                if firstBody.node?.name == "stone" && !firstBody.isDynamic && secondBody.node?.name != "🔱" && secondBody.node?.name != "💠" && !🔋   {
                    stoneVersusLaser(firstBody: firstBody, secondBody: secondBody, contactPoint: contact.contactPoint)
                } else if firstBody.isDynamic || (🔋 && secondBody.node?.name == "💠") {
                    baddiePointsHelper(firstBody: firstBody, secondBody: secondBody, contactPoint: contact.contactPoint)
                } else {
                    worldVersusLaser(firstBody: firstBody, secondBody: secondBody, contactPoint: contact.contactPoint)
            }
            case badFishCategory | laserbeam :
                if firstBody.isDynamic || (🔋 && secondBody.node?.name == "💠") {
                    baddiePointsHelper(firstBody: firstBody, secondBody: secondBody, contactPoint: contact.contactPoint)
                } else {
                    worldVersusLaser(firstBody: firstBody, secondBody: secondBody, contactPoint: contact.contactPoint)
                    
            }
            case badGuyCategory | laserbeam :
                baddiePointsHelper(firstBody: firstBody, secondBody: secondBody, contactPoint: contact.contactPoint)
            case laserbeam | itemCategory :
                if secondBody.isDynamic || (🔋 && firstBody.node?.name == "💠") {
                    goodiePointsHelper(firstBody: firstBody, secondBody: secondBody, contactPoint: contact.contactPoint)
                } else {
                    laserVersusFloater(firstBody: firstBody, secondBody: secondBody, contactPoint: contact.contactPoint)
            }
            case laserbeam | fishCategory :
                if secondBody.isDynamic || (🔋 && firstBody.node?.name == "💠") {
                    goodiePointsHelper(firstBody: firstBody, secondBody: secondBody, contactPoint: contact.contactPoint)
                } else {
                    laserVersusFloater(firstBody: firstBody, secondBody: secondBody, contactPoint: contact.contactPoint)
            }
            case laserbeam | charmsCategory :
                goodiePointsHelper(firstBody: firstBody, secondBody: secondBody, contactPoint: contact.contactPoint)
            case tractorCategory | itemCategory, tractorCategory | charmsCategory, tractorCategory | fishCategory :
                
                if let prize = secondBody.node as? SKSpriteNode {
                    tractorBeamedThisItem(prize: prize)
            }
            
            case heroCategory | levelupCategory :
                
                /*print(secondBody.node?.name)*/
                
                levelUpHelper()
                
                
                if secondBody.node?.name == "🌀" {
                    if level > 0 && level < 4 {
                        level = 5
                    }
                }
                
                GameStartup.gs.saveScores(level: level, highlevel: highlevel, score: score, hscore: highscore, lives: lives)
                
                hero.physicsBody?.velocity = CGVector.zero
                hero.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 0.0))
                
                let easeOut: SKAction = SKAction.move(to: CGPoint.zero, duration: 0.0)
                easeOut.timingMode = SKActionTimingMode.easeOut
                ThumbPad.run(easeOut)
                TouchPad(velocity: CGVector.zero, zRotation: 0.0)
                
                removeHero()
                removeGUI()
                
                
                //self.removeAllActions()
                //self.removeAllChildren()
                //self.removeFromParent()
                
                
                //Loads the LevelUp Scene
                func starPlayrOneLevelUpX(world:SKNode?, moving:SKNode?, hero: SKSpriteNode?, tractor: SKSpriteNode?) {
                    
                    guard let world = world,
                        let moving = moving,
                        let hero = hero,
                        let tractor = tractor
                        else { return }
                    
                    hero.physicsBody?.velocity = CGVector( dx: 0, dy: 0 )
                    hero.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 0.0))
                    hero.speed = 0
                    hero.removeFromParent()
                    tractor.removeFromParent()
                    moving.speed = moving.speed / 2
                    world.speed =  world.speed / 2
                                        
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                        guard let self = self else { return }
                        let levelup = LevelUp( size: self.size )
                        levelup.runner()
                        self.size = setSceneSizeForGame()
                        levelup.scaleMode = .aspectFill
                        self.view?.presentScene(levelup)
                    }
                        
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
                        guard let self = self else { return }
                        self.removeAllChildren()
                        self.removeAllActions()
                        self.removeFromParent()
                    }
                }
                
                starPlayrOneLevelUpX(world:world, moving:moving, hero: hero, tractor: tractor)
            
            
            
            
            case heroCategory | worldCategory, heroCategory | badGuyCategory, heroCategory | badFishCategory :
                
                if ( shield ) {
                    return
                }
                
                stopIt(secondBody: secondBody, contactPoint: contact.contactPoint)
            default :
                return
            /*
             //used for debugging
             print(String("** begin unexpected contact ->"))
             
             if let _ = firstBody.node as? SKSpriteNode  {
             print(String(describing: firstBody.node?.name))
             }
             
             if let _ = secondBody.node as? SKSpriteNode  {
             print(String(describing: secondBody.node?.name))
             }
             
             print(String("<- end unexpected contact **"))
             */
            
        }
        
    }
    
    
    
    func stopIt(secondBody: SKPhysicsBody, contactPoint: CGPoint) {
        //save first
        GameStartup.gs.saveScores(level: level, highlevel: highlevel, score: score, hscore: highscore, lives: lives)
        
        if moving.speed > 0 {
            
            remove(body:secondBody)
            removeGUI()
            LostLife(contactPoint: contactPoint)
            Explosion()
            if lives <= 0 {
                EndGame()
            } else {
                RestartLevel()
            }
        }
    }
    
    func removeHero() {
        
        removeNode(node: canape)
        removeNode(node: tractor)
        removeNode(node: hero)
        
    }
    
    func removeGUI() {
        if let pad = cam.childNode(withName: "ArcadeJoyPad"), let hud = cam.childNode(withName: "HeadsUpDisplay")  {
            pad.removeFromParent()
            hud.removeAllChildren()
            hud.removeFromParent()
        }
    }
    
    func LostLife(contactPoint: CGPoint) {
        
        smokeM(pos: contactPoint)
        moving.speed = 0
        
        removeGUI()
        
        if settings.music {
            audioPlayer?.numberOfLoops = 0
            audioPlayer?.stop()
            audioPlayer?.volume = 0.0
        }
        
        lives = lives - 1
        
        if lives >= 0 {
            livesLabelNode.text = String(livesDisplay[lives])
        }
        
        GameStartup.gs.saveScores(level: level, highlevel: highlevel, score: score, hscore: highscore, lives: lives)
    }
    
    
    
    func EndGame() {
        print("ENDGAME")
        removeHero()
        removeGUI()
        GameStartup.gs.saveScores(level: level, highlevel: highlevel, score: score, hscore: highscore, lives: lives)
        
        //Loads the game over scene
        func gameOver(world:SKNode, moving:SKNode, hero: SKSpriteNode, tractor: SKSpriteNode) {
            
            let explosion = SKEmitterNode(fileNamed: "fireParticle.sks")!
            explosion.alpha = 0.5
            explosion.position = hero.position
            scene?.addChild(explosion)
            tractor.removeFromParent()
            hero.physicsBody?.affectedByGravity = true
            moving.speed = moving.speed / 2
            world.speed =  world.speed / 2
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                guard let self = self else { return }
                let gameOverScene = GameOver( size: self.size )
                gameOverScene.runner()
                self.size = setSceneSizeForGame()
                gameOverScene.scaleMode = .aspectFill
                self.view?.presentScene(gameOverScene)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                backParalax.removeFromParent()
            }
        }
        
        gameOver(world:world!, moving:moving, hero:hero, tractor:tractor)
    }
    
    
    func Explosion() {
        if let explosion = SKEmitterNode(fileNamed: "fireParticle.sks") {
            explosion.alpha = 0.5
            explosion.zPosition = 175
            explosion.position = hero.position
            addChild(explosion)
            
            explosion.run(SKAction.sequence([
                SKAction.scale(to: -1.5, duration: 0.6),
            ]))
            
            explosion.run(SKAction.sequence([
                SKAction.scale(to: 0.5, duration: 0.6),
                SKAction.fadeAlpha(to: 0, duration: 0.6),
                SKAction.wait(forDuration: 3.0),
                SKAction.run {
                    explosion.removeFromParent()
                }
            ]))
        }
        
        moving.speed = moving.speed / 2
        world?.speed = (world?.speed)! / 2
        scene?.childNode(withName: "world")?.removeAllActions()
        
    }
    
    
    func RestartLevel() {
        
        removeHero()
        
        scene?.run(SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.run() {
                
                self.moving.speed = 1
                self.world?.speed = 0
                
                let runResetWorld = SKAction.run() {
                    let resetWorld = SKAction.moveTo(x: (self.world?.position.x)!, duration: 0)
                    self.scene?.childNode(withName: "world")!.run(resetWorld)
                    self.scene?.childNode(withName: "world")!.speed = 1
                }
                
                let runWorld = SKAction.run() {
                    self.moving.speed       = 1
                    
                    guard let gamestartup = self.readyPlayerOne() else { return }
                
                    self.hero = gamestartup.hero
                    self.canape = gamestartup.canape
                    self.tractor = gamestartup.tractor
                    
                    if settings.emoji == 2 {
                        self.emojiAnimation(emojis:["🙈","🙊","🙉","🐵"])
                    }
                    
                    self.bombsbutton 	=  gamestartup.bombsbutton
                    self.firebutton 	= gamestartup.firebutton
                    self.bombsbutton2 	= gamestartup.bombsbutton2
                    self.firebutton2 	= gamestartup.firebutton2
                    
                    if settings.music {
                        self.audioPlayer?.numberOfLoops = -1
                        self.audioPlayer?.play()
                        self.audioPlayer?.volume = 1.0
                    } else {
                        self.audioPlayer?.numberOfLoops = 0
                        self.audioPlayer?.stop()
                        self.audioPlayer?.volume = 0.0
                    }
                    
                    self.scene?.childNode(withName: "world")!.speed = 1
                }
                
                //Reset Game Action Sequence
                self.scene?.run(SKAction.sequence([runResetWorld,runWorld]))
            }
        ]))
    }
    
    
    // Find the Score
    // And return 1 if we can't find it
    func tallyPoints(name:String?) -> Int {
        
        guard let name = name else {
            print("No name is present.")
            return(0)
        }
        
        if name.isEmpty {
            print("Name is Empty.")
            return(0)
        }
        
        let pts = 1
        
        if name == "❣️" && lives >= 0 && lives <= 9 {
            lives = lives + 1
            var emoji = "👽"
            
            if settings.emoji == 2 {
                emoji = "🐵"
            }
            
            emoji = "👽"
            livesLabelNode.text = String(repeating: emoji, count: lives)
            
            if settings.sound {
                let fire: SKAction = SKAction.playSoundFileNamed("extralife.m4a", waitForCompletion: false)
                self.run(fire)
            }
        }
        
        
        
        //gives our ship shields
        if name == "🛡"  {
            /* Power Ups */
            shield = true
            
            if var l = livesLabel.text, !l.contains("🛡") {
                l += "🛡"
                
                hero.alpha = 0.75
                
                //MARK: aura particle emitter
                if let aura = SKEmitterNode(fileNamed: "aura") {
                    aura.alpha = 0.25
                    aura.speed = 1
                    aura.name = "aura"
                    aura.setScale(0.5)
                    hero.addChild(aura)
                }
            }
            
            if settings.sound {
                let fire: SKAction = SKAction.playSoundFileNamed("doublelaser.m4a", waitForCompletion: false)
                self.run(fire)
            }
            
        }
        
        
        //gives our ship double lasers
        if name == "🔫" || name == "‼️"  {
            doublelaser = 1
            
            if var l = livesLabel.text, !l.contains("🔫") {
                l += "🔫"
            }
            
            if settings.sound {
                let fire: SKAction = SKAction.playSoundFileNamed("doublelaser.m4a", waitForCompletion: false)
                self.run(fire)
            }
        }
        
        //gives our ship double lasers
        if name == "💠" {
            🔋 = true
            
            if var l = livesLabel.text, !l.contains("💠") {
                l += "💠"
            }
            
            if settings.sound {
                let fire: SKAction = SKAction.playSoundFileNamed("doublelaser.m4a", waitForCompletion: false)
                self.run(fire)
            }
        }
        
        //gives our trident bombs
        if name == "🔱" {
            🔱 = true
            
            if var l = livesLabel.text, !l.contains("🔱") {
                l += "🔱"
            }
            
            if settings.sound {
                let fire: SKAction = SKAction.playSoundFileNamed("doublelaser.m4a", waitForCompletion: false)
                self.run(fire)
            }
        }
        
        /* guard did not stop from crashing, so using this instead */
        if let score = (scoreDict[name]) {
            return score
        } else {
            print("if let score found : missing score for: " + name)
            return (pts)
        }
    }
    
    //MARK: UpdateScore
    func updateScore(extraPoints:Int) {
        //let updateScore = SKAction.run() {
        self.score = self.score + extraPoints
        
        if self.score >= self.highscore {
            self.highscore = self.score
            self.highScoreLabelNode.text = String(self.highscore)
        }
        
        self.scoreLabelNode.text = String(self.score)
        
        if moving.speed == 0 {
            GameStartup.gs.saveScores(level: self.level, highlevel: self.highlevel, score: self.score, hscore:self.highscore, lives: self.lives)
        }
    }
 }
 
 
 extension SKSpriteNode {
    func addGlow(radius: Float = 16) {
        let effectNode = SKEffectNode()
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.filter = CIFilter( name: "CIMotionBlur", parameters: [ "inputRadius":radius,"inputAngle": CGFloat.pi / 2 ] )
        effectNode.shouldRasterize = true
        addChild(effectNode)
    }
 }

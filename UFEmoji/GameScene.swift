 //
 //  GameScene.swift
 //  UF Emoji
 //
 //  Created by Todd Bruss on 12/3/15.
 //  Copyright (c) 2015 Todd Bruss. All rights reserved.
 //
 
 
 // Levels
 
 // 🏉 = Right End / Rugby
 // 🏀 = Right Guard / Basketball
 // 🏐 = Right Center / Volleyball
 // 🏈 = Left Center / Football
 // ⚽️ = Left Guard / Soccer
 // ⚾️ = Left End / Baseball
 
 // 😃 = 1
 // 😆 = 2
 // 🤣 = 3
 // 😇 = 4
 // 😉 = 5
 // 😘 = 6
 // 😚 = 7
 // 😝 = 8
 // 🤨 = 9
 // 😎 = 10
 
 
 import SpriteKit
 import AVFoundation
 //import GameplayKit
 
 extension SKSpriteNode {
    
    func addGlow(radius: Float = 16) {
        let effectNode = SKEffectNode()
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.filter = CIFilter(name: "CIMotionBlur", parameters: ["inputRadius":radius,"inputAngle":CGFloat.pi/2])
        effectNode.shouldRasterize = true
        addChild(effectNode)
    }
 }
 
 //var transparentimage = UIImage()
 //var heroPos = CGPoint()
 var headsUpDisplay = SKReferenceNode()
 
 //Back Tonight at
 //8PM EST TIME... Twitch.tv/UFEmoji
 
 //SEE YOU THEN...
 
 // Friday: Troubleshoot the Asteroid Belt Star Wars inspired Level.  mainly its completion. "Not too shabby."
 // Fixed crash bug at end of Asteroid Belt level
 // Add in some better game play design to the it (tonight).
 
 // Tomorrow:
 // Saturday: The Walking Dead MiniGame Level
 
 // If there is time:
 // Sunday: The Legoland MiniGame Level
 
 // Also in the works:
 // Animoji integration
 // New Background Music
 
 // Another Theme (Egyptian / Sand).
 
 
 
 class GameScene: SKScene, ThumbPadProtocol, SKPhysicsContactDelegate, AVAudioPlayerDelegate {
    var firstBody = SKPhysicsBody()
    var secondBody = SKPhysicsBody()
    //var laserbeamer = UInt32()
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
    var backParalax: [SKNode?] = [nil]
    var scoreLabelNode:SKLabelNode!
    var highScoreLabelNode:SKLabelNode!
    var hud: SKNode!
    var highScoreLabel:SKLabelNode!
    var livesLabel:SKLabelNode!
    var livesLabelNode:SKLabelNode!
    var heroLocation:CGPoint = CGPoint.zero
    var TileMap:SKTileMapNode = SKTileMapNode()
    var rockPile:SKNode = SKNode()
    var score = Int()
    var level = Int()
    var highscore = Int()
    var lives = Int()
    var highlevel = Int()
    //let notInUse2:UInt32 = 6
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
    
    //var firstBody: SKphysicsBody?
    //var secondBody: SKphysicsBody?
    var scoreDict: [String:Int] = [:]
    //we can swap these out if we use other emoji ships: 0 through 6
    
    func ParaStartup() {
        
        for node in self.children {
            if (node.name == "world") {
                
                //Texture Map Node Stuff goes here
                for node in node.children {
                    if(node.name == "Rocky") {
                        node.zPosition = 50
                        
                    } else if node.name == "Water" {
                        node.alpha = 0.2
                        node.zPosition = 60
                    }
                }
            }
        }
    }
    
    
    func setupLevel(tileMap: SKTileMapNode? = nil) {
       
        if let tm = tileMap {
            
            let tmr = TMR(TileMap: tm)
            
            for col in (0 ..< tm.numberOfColumns) {
                for row in (0 ..< tm.numberOfRows) {
                    let tileDefinition = tm.tileDefinition(atColumn: col, row: row)
                    var center = tm.centerOfTile(atColumn: col, row: row)
                    
                    //flip this section
                    //if flipsection {
                        //center = CGPoint(x:-center.x, y: center.y)
                    //}

                    //print(center)
                    if let td = tileDefinition, let name = tileDefinition!.name {
                        if name.count > 0 {
                            tmr.tileMapRun(tileDefinition: td, center: center)
                        }
                    }
                    
                    center = CGPoint()
                }
            }
            
            tm.removeAllChildren()
            tm.removeFromParent()
        }
        
        
       
    }
    
   // func setupWater(_ scene:SKScene, tileMap: SKTileMapNode, Hi: String) {
    //    tileMap.zPosition = 60
    //    tileMap.alpha = 0.2
   // }
    
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
        supermanLaser = true
        trident = true
        let logonode = SKSpriteNode(texture: SKTexture(imageNamed: "UFOEmojiLogoLarge"))
        scene?.camera?.addChild(logonode)
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
		
        //badguyai = [:] //MARK TODD
        
        // This is the default of King, Queen Nationality
        KingQueenGlobalDie = 100
        
        trident = false
        supermanLaser = false
        shield = false
        
        doublelaser = 0
        
        
        if (settings.level >= 1 && settings.level <= 10) {
            let soundURL: URL = Bundle.main.url(forResource: "music1", withExtension: "mp3")!
            audioPlayer = try! AVAudioPlayer(contentsOf: soundURL)
        }
        
        if settings.music {
            audioPlayer?.numberOfLoops = 0
            audioPlayer?.stop()
            audioPlayer?.volume = 0.0
        }
        
        super.didMove(to: view)
        cam = SKCameraNode()
        camera = cam
        addChild(cam)
        cam.zPosition = 100
        
        
        headsUpDisplay.name = "HeadsUpDisplay"
        scene?.camera?.addChild(headsUpDisplay)
        headsUpDisplay.zRotation = CGFloat(Double.pi/4)
        
        
        
        let gamestartup = GameStartup().readyPlayerOne(self)
        
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
        scoreDict["🤯"] =  00 //super villian leader
        scoreDict["💎"] = 110 //rare
        scoreDict["👑"] = 115 //rare
        scoreDict["❣️"] = 120 //extra life (displays him/herself in the game)
        scoreDict["🔫"] = 130 //super rare marker for double laser beams
        
        scoreDict["🔱"] = 140 //super rare trident (super bomb)
        scoreDict["‼️"] = 130 //super rare shields (cloaked ghost, move through walls)
        scoreDict["🛡"] = 150 //super rare shields (cloaked ghost, move through walls)
        scoreDict["💠"] = 150 //super rare shields (cloaked ghost, move through walls)
        scoreDict["gold"] = 2
        scoreDict["land"] = 1
        scoreDict["dirt"] = 1
        scoreDict["grass"] = 2
        scoreDict["desert"] = 2
        scoreDict["sand"] = 3
        scoreDict["stone"] = 3
        
        
        hero = gamestartup.hero
        canape = gamestartup.canape
        tractor = gamestartup.tractor
        tractor.addGlow()
        
        if let _ = gamestartup.bombsbutton {
            bombsbutton = gamestartup.bombsbutton!
        }
        
        firebutton = gamestartup.firebutton
        bombsbutton2 = gamestartup.bombsbutton2
        firebutton2 = gamestartup.firebutton2
        
        (level, highlevel, score, highscore, lives) = GameStartup().loadScores()
        
        world = childNode(withName: "world")
        
        // 😃 = 1
        // 😆 = 2
        // 🤣 = 3
        // 😇 = 4
        // 😉 = 5
        // 😘 = 6
        // 😚 = 7
        // 😝 = 8
        // 🤨 = 9
        // 😎 = 10
        
        // 🏉 = Right End
        // 🏀 = Left/Right Guard
        // 🏈 = Center
        // ⚽️ = Right/Left Guard
        // ⚾️ = Left End
        
        let subLevels = UInt32(8) //  no larger than 8 should be allowed here
        let sectionWidth = CGFloat(1440)
        
        //no flip : yes flip
        let position = [["⚾️","🏉"],["⚽️","🏀"],["🏈","🏐"],["🏀","⚽️"],["🏉","⚾️"]]
        let sectional = ["😃","😆","🤣","😇","😉","😘","😚","😝","🤨","😎"]
        var spot = 2
        var counter = -1
        //Level Prefix
        var prefix = "🦕"
        // Defaults
        var backgroundArray = [(name:"", alpha: CGFloat(1.0)),
                               (name:"", alpha:CGFloat(1.0)),
                               (name:"blue-mtns", alpha:CGFloat(1.0)) ]
        
        var minilevelname = "" //default
        
        //level = 1
        switch level {
            
            
        case 1..<100:
            prefix = "🦕"
            backgroundArray = [(name:"", alpha: CGFloat(1.0)),
                               (name:"", alpha:CGFloat(1.0)),
                               (name:"desertMtns", alpha:CGFloat(1.0)) ]
            spot = 0
            counter = 1
        case 50000:
            print("EWFWFWEEWF")
            prefix = "🚀"
            minilevelname = "🚀🚀🚀" // can be randomized later
            spot = 0
            counter = 1
        case 6..<9:
            prefix = "📓"
            backgroundArray = [(name:"skyMtns", alpha: CGFloat(1.0)),
                               (name:"", alpha:CGFloat(1.0)),
                               (name:"", alpha:CGFloat(1.0)) ]
            spot = 2
            counter = -1
        case 10:
            prefix = "🧟‍♀️"
            minilevelname = "🧟‍♀️🧟‍♀️🧟‍♀️" // can be randomized later
            spot = 0
            counter = 1
            
            backgroundArray = [(name:"skyMtns", alpha: CGFloat(0.5)),
                               (name:"", alpha:CGFloat(0.25)),
                               (name:"", alpha:CGFloat(0.0)) ]
        default :
            prefix = "🦕"
            spot = 2
            counter = -1
        }
        
        
        
        //// if level != 0 {
        for iteration in -spot...spot  {
            let sublevel = Int(arc4random_uniform(subLevels)) //6
            let sector = sectional[sublevel]
            let flip = Int(arc4random_uniform(2))
            var filename = "" //default
            
            //turn on the minigame level
            //Mini game levels will be every 5 levels
            if level % 50000 == 0 && 1 == 2 {
                filename = minilevelname
            } else {
                filename = (prefix + position[counter][flip] + sector)
                filename = (prefix + position[counter][flip] + sector)

            }
            
            
            //Test the mini level entry
            //if ( iteration == 2 && level < 1000 ) {
            //filename = "🦕⚽️🤣"
            filename = "level1"

            //}
            
            /*
             print("=->")
             print("counter: " + String(counter))
             print("level:   " + String(level))
             print("prefix:  " + String(prefix))
             
             print("sublevel:" + String(sublevel))
             print("sector:  " + String(sector))
             print("flip:    " + String(flip))
             print("filename:" + String(filename))
             print("<-=")
             */
            
            //Check if level exists first (safe)
            if let _ = GameScene(fileNamed: filename ) {
                if SKReferenceNode(fileNamed: filename) != nil {
                   
                
                   
                   // DispatchQueue.main.async { [weak self] in
                        let section : SKReferenceNode? = SKReferenceNode(fileNamed: filename)
                    
                        self.scene?.addChild(section!)
                        
                        if self.level != 10000 {
                            section?.position.x = sectionWidth * CGFloat(iteration)
                        } else {
                            section?.position = CGPoint(x:0,y:0)
                        }
                    
                                 
                    	skView.isPaused = true
						
                        if let level = section?.children.first?.children {
                        	//No longer hard encoded
                            for land in level {
                                
                                if let name = land.name {
                                    if let midsection = section?.childNode(withName: "//" + name ) as? SKTileMapNode {
                                        self.setupLevel( tileMap: midsection)
                                    }
                                }
                        	}
                    	}
             
	
                    	skView.isPaused = false


                   // }
                    
                    
                    
                 
                    
                }
            } else {
                print("//*** Level not found:" + filename + " ***//")
            }
        }
        
        ParaStartup()
        
        for node in self.children {
            if (node.name == "world") {
                
                //Texture Map Node Stuff goes here
                for node in node.children {
                    
                    if(node.name == "Rocky") {
                        
                        rockBounds = node.frame
                        
                        if settings.level != 50000 {
                            scene?.physicsWorld.gravity = CGVector(dx: 0.0, dy: -3) //mini
                        } else {
                            scene?.anchorPoint = CGPoint(x:0.5,y:0.5)
                            scene?.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0) //mini
                        }
                        //scene?.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
                        
                        scene?.physicsWorld.contactDelegate = self
                        //print("Rocky")
                        
                        //world container  LET's PLAY!!!!
                        
                        if level != 50000 {
                            scene?.physicsBody = SKPhysicsBody(edgeLoopFrom: rockBounds)
                            
                        } else {
                            //minigame
                            let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0,y: 0), radius: CGFloat((rockBounds.height - ((scene?.frame.width)! / 2)) / 2), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
                            scene?.physicsBody = SKPhysicsBody(edgeLoopFrom: circlePath.cgPath)
                        }
                        
                        scene?.physicsBody?.categoryBitMask = wallCategory //2 + 8 + 128 + 256 + 512 + 1024
                        scene?.physicsBody?.collisionBitMask = 0
                        scene?.physicsBody?.restitution = 0.02
                        scene?.physicsBody?.contactTestBitMask = 0
                        
                        
                        //container for bombBounds
                        let bombBounds = CGRect(x: node.frame.origin.x ,y: node.frame.origin.y, width: node.frame.width, height: node.frame.height + 128)
                        
                        let addnode = SKNode()
                        addnode.name = "bombBounds"
                        addnode.zPosition = -10000
                        
                        addnode.physicsBody = SKPhysicsBody(edgeLoopFrom: bombBounds)
                        addnode.physicsBody?.categoryBitMask = bombBoundsCategory;
                        scene?.addChild(addnode)
                        
                        
                        let node = SKNode()
                        let laserBounds = CGRect(x: ((scene?.frame.origin.x)! - 5 ), y: (scene?.frame.origin.y)!, width: (scene?.frame.width)! + 10, height: ((scene?.frame.height)!))
                        node.physicsBody = SKPhysicsBody(edgeLoopFrom: laserBounds )
                        node.name = "🔲"
                        node.physicsBody?.categoryBitMask = laserBorder
                        node.physicsBody?.collisionBitMask = 0
                        node.physicsBody?.contactTestBitMask = 0
                        node.physicsBody?.isDynamic = false
                        node.physicsBody?.affectedByGravity = false;
                        node.physicsBody?.restitution = 0;
                        node.speed = 0
                        node.yScale = 1.5
                        self.camera?.addChild(node)
                    }
                }
            }
        }
        
        scene?.addChild(moving)
        
        //print(rockBounds.width)
        
        //if not a mini game, do this
        if level != 50000 {
            
            var counter = -1
            for bkgdArr in backgroundArray {
                counter += 1
                
                backParalax.append( SKNode() )
                
                if let bp = backParalax[counter] {
                  
                    scene?.addChild(bp)

                    let texture = SKTexture(imageNamed: bkgdArr.name)
                    let width = texture.size().width
                    let rounded = Int(round( rockBounds.width / width ))
                    
                    for i in -rounded...rounded  {
                        let sprite = SKSpriteNode(texture: texture)
                        sprite.position = CGPoint(x: CGFloat(i) * width, y: 0)
                        sprite.alpha = bp.alpha
                        bp.addChild(sprite)
                        bp.zPosition = -240 + CGFloat(counter)
                    }
                }
            }
         
            
            /*
            backParalax3 = SKNode()
            scene?.addChild(backParalax3!)

            let cloudsTexture = SKTexture(imageNamed: backgroundArray[1].name)
            let cloudsWidth = cloudsTexture.size().width
             rounded = Int(round( rockBounds.width / cloudsWidth ))
            for i in -rounded...rounded {
                let sprite = SKSpriteNode(texture: cloudsTexture)
                sprite.position = CGPoint(x: CGFloat(i) * cloudsWidth, y: 0)
                sprite.alpha = backgroundArray[1].alpha
                self.backParalax3?.addChild(sprite)
                self.backParalax3?.zPosition = -238
            }
            
           
            backParalax2 = SKNode()
            scene?.addChild(backParalax2!)
            
            let mtnsTexture = SKTexture(imageNamed:  backgroundArray[2].name)
            let mtnsWidth = mtnsTexture.size().width
             rounded = Int(round( rockBounds.width / mtnsWidth ))
            print(rounded)
            

            for i in -rounded...rounded {
                let sprite = SKSpriteNode(texture: mtnsTexture)

                sprite.position = CGPoint(x: CGFloat(i) * mtnsWidth, y: 0)
                sprite.alpha = backgroundArray[2].alpha
                
                self.backParalax2?.addChild(sprite)
                self.backParalax2?.zPosition = -236
            }
                */
            
        } else {
            
            var backParalax: SKNode? = nil

            backParalax = SKNode()
            scene?.addChild(backParalax!)
            let starryNightTexture = SKTexture(imageNamed: "starfield1")
            let sprite = SKSpriteNode(texture: starryNightTexture)
            sprite.position = CGPoint(x: 0, y: 0)
            sprite.alpha = 1.0
            backParalax?.addChild(sprite)
            backParalax?.zPosition = -240
        }
        
        self.childNode(withName: "world")?.speed = 1.0
        moving.speed = 1
        
        if settings.emoji == 2 {
            emojiAnimation(emojis:["🙈","🙊","🙉","🐵"])
        }
        
        screenHeight = (scene?.frame.size.height)! / 2 - 64
        
        let sceneheight = (scene?.frame.size.height)! / 2
        let difference = CGFloat(20)
        let labelheight = sceneheight - difference
        let scoreheight = sceneheight - (difference * CGFloat(2))
        let indent = CGFloat((scene?.frame.size.width)! / 2) - 7.5 * CGFloat(settings.mode)
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
        if settings.level != 50000 {
            
            if hero == nil || canape == nil {
                return
            }
            
            cam.position.x = hero.position.x
            canape.zRotation = hero.zRotation
            
            if let bp1 = backParalax.first {
                bp1?.position.x = hero.position.x / -2
            }
            //backParalax3?.position.x = hero.position.x / -3
            
        } else {
            
            if hero == nil {
                return
            }
            
            cam.position = hero.position
            cam.zRotation = hero.zRotation
        }
        
        
        /*
         cam.position = hero.position
         cam.zRotation = hero.zRotation
         */
    }
    
    
    public func emojiAnimation(emojis:Array<String>) {
        
        let emojiLab = hero.children[0] as! SKLabelNode
        
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
        
        super.touchesBegan(touches as Set<UITouch>, with: event)
        for touch: AnyObject in touches {
            let location: CGPoint = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            
            if let name = touchedNode.name
            {
                //bombAlternator = !bombAlternator
                //laserAlternator = !laserAlternator
                
                if name == "fire-right" {
                    GameProjectiles(laserbeak: laserbeam, scene: self, hero: (hero.position, hero.zRotation), reverse:false ).firebomb(firebomb: firebutton!)
                }
                
                if name == "fire-left" {
                    GameProjectiles(laserbeak: laserbeam, scene: self, hero: (hero.position, hero.zRotation), reverse:true ).firebomb(firebomb: firebutton2!)
                }
                
                if name == "fire-down" {
                    GameProjectiles(bombsaway: laserbeam, scene: self, hero: (hero.position, hero.zRotation, (hero.physicsBody?.velocity)!), reverse: false).firebomb(firebomb: bombsbutton!)
                }
                
                if name == "fire-top" {
                    GameProjectiles(bombsaway: laserbeam, scene: self, hero: (hero.position, hero.zRotation, (hero.physicsBody?.velocity)!), reverse:true ).firebomb(firebomb: bombsbutton2!)
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
    
    func ThumbPad(velocity: CGVector, zRotation: CGFloat) {
        
        
        if velocity != CGVector.zero {
            hero.physicsBody?.linearDamping = CGFloat(0)
            let rot = SKAction.rotate(toAngle: zRotation, duration: 0.005)
            hero.run(rot)
            
            hero.physicsBody?.applyForce(velocity)
            //hero.physicsBody?.applyImpulse(velocity)
        } else if velocity == CGVector.zero {
            
            if case (hero.physicsBody?.linearDamping)! = CGFloat(0) {
                //animate to look not so jerky
                
                //this will make the minigame harder!!
                //if settings.level != 5 {
                //print(settings.level)
                let rot = SKAction.rotate(toAngle: 0.0, duration: 0.08)
                hero.run(rot)
                hero.physicsBody?.linearDamping = CGFloat(40)
                //}
                
            }
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
            scene?.addChild(smoke)
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
            scene?.addChild(smoke)
        }
        
        if settings.sound {
            let explosion: SKAction = SKAction.playSoundFileNamed("boomFire2.m4a", waitForCompletion: false)
            run(explosion)
        }
    }
    
    func magicP (pos: CGPoint) {
        
        //Using if let for SKEmitterNodes should fix any faulty optionals
        //Surprised we got one. If let's are awesome in swift.
        //I have not had good luck with "Guard" statements in case you are wondering
        if let smoke = SKEmitterNode(fileNamed: "magicParticle") {
            let fadeToZero = SKAction.fadeAlpha(to: 0.0, duration:TimeInterval(2.0))
            let removeFromParent = SKAction.removeFromParent()
            let destroyVaporDelay = SKAction.wait(forDuration: 2.0)
            smoke.run(SKAction.sequence([destroyVaporDelay,fadeToZero,removeFromParent]))
            smoke.position = pos
            smoke.speed = 5
            smoke.zPosition = 150
            scene?.addChild(smoke)
        }
        
        
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
                //firstBody.node?.setScale(1.15)
                
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
    
    
    // Here we are super careful not cause a crash
    func remove(body:SKPhysicsBody?) {
        if body == nil {
            return
        }
        
        if let b = body {
            if (b.node == nil) {
                return
            }
            
            //remove from parent
            if let node = b.node as? SKSpriteNode  {
                let r = SKAction.removeFromParent()
                node.run(r)
            }
        }
     
    }
    
    // Here we are super careful not cause a crash
    func removeNode(node:SKSpriteNode?) {
        if (node == nil) {
            return
        }
        
        if let n = node {
            let r = SKAction.removeFromParent()
            n.run(r)
        }
  
    }
    
    
    func goodiePointsHelper(firstBody:SKPhysicsBody, secondBody:SKPhysicsBody, contactPoint: CGPoint) {
        
        if secondBody.node?.name == nil {
            return
        }
        
        if let _ = secondBody.node?.name {
            //if ( secondBody.node?.name != nil) {
            let extraPoints = tallyPoints(name: (secondBody.node?.name)!)
            updateScore(extraPoints:extraPoints )
            magicP(pos: contactPoint)
            remove(body: firstBody)
            remove(body: secondBody)
            //}
        }
        
    }
    
    
    func levelUpHelper() {
        level = level + 1
        
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
        
        if  ( contact.bodyA.categoryBitMask ==  0 || contact.bodyB.categoryBitMask == 0 || contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil  ) {
            return
        }
        
        if  ( contact.bodyA.node == nil || contact.bodyB.node == nil || contact.bodyA.node?.name == nil || contact.bodyB.node?.name == nil ) {
            return
        }
        
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
            
            if firstBody.node?.name == "stone" && !firstBody.isDynamic && secondBody.node?.name != "🔱" && secondBody.node?.name != "💠" && !supermanLaser   {
                stoneVersusLaser(firstBody: firstBody, secondBody: secondBody, contactPoint: contact.contactPoint)
            } else if firstBody.isDynamic || (supermanLaser && secondBody.node?.name == "💠") { 
                baddiePointsHelper(firstBody: firstBody, secondBody: secondBody, contactPoint: contact.contactPoint)
            } else {
                worldVersusLaser(firstBody: firstBody, secondBody: secondBody, contactPoint: contact.contactPoint)
            }
        case badFishCategory | laserbeam :
            if firstBody.isDynamic || (supermanLaser && secondBody.node?.name == "💠") {
                baddiePointsHelper(firstBody: firstBody, secondBody: secondBody, contactPoint: contact.contactPoint)
            } else {
                worldVersusLaser(firstBody: firstBody, secondBody: secondBody, contactPoint: contact.contactPoint)
                
            }
        case badGuyCategory | laserbeam :
            baddiePointsHelper(firstBody: firstBody, secondBody: secondBody, contactPoint: contact.contactPoint)
        case laserbeam | itemCategory :
            if secondBody.isDynamic || (supermanLaser && firstBody.node?.name == "💠") {
                goodiePointsHelper(firstBody: firstBody, secondBody: secondBody, contactPoint: contact.contactPoint)
            } else {
                laserVersusFloater(firstBody: firstBody, secondBody: secondBody, contactPoint: contact.contactPoint)
            }
        case laserbeam | fishCategory :
            if secondBody.isDynamic || (supermanLaser && firstBody.node?.name == "💠") {
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
            
            GameStartup().saveScores(level: level, highlevel: highlevel, score: score, hscore: highscore, lives: lives)
            
            removeHero()
            removeGUI()
            starPlayrOneLevelUp(world:world!, moving:moving, scene:self, hero:hero, tractor:tractor)
            
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
        GameStartup().saveScores(level: level, highlevel: highlevel, score: score, hscore: highscore, lives: lives)
        
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
        
        if let _ = cam.childNode(withName: "ArcadeJoyPad")  {
            cam.childNode(withName: "ArcadeJoyPad")?.removeFromParent()
        }
        
        if let _ = cam.childNode(withName: "HeadsUpDisplay") {
            cam.childNode(withName: "HeadsUpDisplay")?.removeAllChildren()
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
        
        GameStartup().saveScores(level: level, highlevel: highlevel, score: score, hscore: highscore, lives: lives)
    }
    
    
    func EndGame() {
        removeHero()
        GameStartup().saveScores(level: level, highlevel: highlevel, score: score, hscore: highscore, lives: lives)
        gameOver(world:world!, moving:moving, scene:self, hero:hero, tractor:tractor)
    }
    
    
    func Explosion() {
        if let explosion = SKEmitterNode(fileNamed: "fireParticle.sks") {
            explosion.alpha = 0.5
            explosion.zPosition = 175
            explosion.position = hero.position
            scene?.addChild(explosion)
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
                self.world?.speed = 1
                
                let runResetWorld = SKAction.run() {
                    let resetWorld = SKAction.moveTo(x: (self.world?.position.x)!, duration: 0)
                    self.scene?.childNode(withName: "world")!.run(resetWorld)
                    self.scene?.childNode(withName: "world")!.speed = 1
                }
                
                let runWorld = SKAction.run() {
                    self.moving.speed       = 1
                    
                    let gamestartup = GameStartup().readyPlayerOne(self)
                    
                    self.hero = gamestartup.hero
                    self.canape = gamestartup.canape
                    self.tractor = gamestartup.tractor
                    
                    if settings.emoji == 2 {
                        self.emojiAnimation(emojis:["🙈","🙊","🙉","🐵"])
                    }
                    
                    if let _ = gamestartup.bombsbutton {
                        self.bombsbutton = gamestartup.bombsbutton!
                    }
                    
                    self.firebutton = gamestartup.firebutton
                    
                    self.bombsbutton2 = gamestartup.bombsbutton2
                    self.firebutton2 = gamestartup.firebutton2
                    
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
        
        
        
        let x = false
		
        
        
        //gives our ship shields
        if name == "🛡"  {
            /* Power Ups */
            shield = true;
            
            hero.alpha = 0.5
            if let l = livesLabel.text, x == l.contains("🛡") {
                if !x {
                    livesLabel.text! += "🛡"
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
            
            if let l = livesLabel.text, x == l.contains("🔫") {
                if !x {
                    livesLabel.text = livesLabel.text! + "🔫"
                }
            }
            
            if settings.sound {
                let fire: SKAction = SKAction.playSoundFileNamed("doublelaser.m4a", waitForCompletion: false)
                self.run(fire)
            }
        }
        
        //gives our ship double lasers
        if name == "💠" {
            supermanLaser = true
            
            
            if let l = livesLabel.text, x == l.contains("💠") {
            	if !x {
            	    livesLabel.text! += "💠"
           	 	}
            }
            
           
            
            if settings.sound {
                let fire: SKAction = SKAction.playSoundFileNamed("doublelaser.m4a", waitForCompletion: false)
                self.run(fire)
            }
        }
        
        //gives our trident bombs
        if name == "🔱" {
            trident = true
            
            
            if let l = livesLabel.text, x == l.contains("🔱") {
                if !x {
                     livesLabel.text! += "🔱"
                }
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
            GameStartup().saveScores(level: self.level, highlevel: self.highlevel, score: self.score, hscore:self.highscore, lives: self.lives)
        }
    }
    
  /*  func getImageWithColor(color: UIColor, size: CGSize) -> UIImage
    {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width, height: size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }(*/
 }


 //
 //  GameScene.swift
 //  UF Emoji
 //
 //  Created by Todd Bruss on 12/3/15 to 5/9/20
 //  Copyright (c) 2015 Todd Bruss. All rights reserved.
 //
 
 import SpriteKit
 import AVFoundation

 var headsUpDisplay = SKReferenceNode()

 class GameScene: SKScene, ThumbPadProtocol, SKPhysicsContactDelegate, AVAudioPlayerDelegate {
    var firstBody = SKPhysicsBody()
    var secondBody = SKPhysicsBody()
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
    var backParalax: SKNode? = nil
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
    //we can swap these out if we use other emoji ships: 0 through 6
    
    func ParaStartup() {
        
        for node in self.children {
            if (node.name == "world") {
                
                //Texture Map Node Stuff goes here
                for node in node.children {
                    if(node.name == "Rocky") {
                        node.zPosition = 50
                        
                    }
                }
            }
        }
    }
    
    
    func setupLevel(tileMap: SKTileMapNode? = nil) {
        guard var tileMap = tileMap else { return }
            let tmr = TMRX(TileMap: tileMap)
            
            for col in (0 ..< tileMap.numberOfColumns) {
                for row in (0 ..< tileMap.numberOfRows) {
                    let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row)
                    var center = tileMap.centerOfTile(atColumn: col, row: row)
                    
                    if let td = tileDefinition, let name = td.name {
                        if !name.isEmpty {
                            tmr.tileMapRun(tileDefinition: td, center: center)
                        }
                    }
                    
                    center = CGPoint()
                }
            }
            
            tileMap.removeAllChildren()
            tileMap.removeFromParent()
        	tileMap = SKTileMapNode()
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
                
        // This is the default of King, Queen Nationality
        KingQueenGlobalDie = 100
        
        trident = false
        supermanLaser = false
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
        
        super.didMove(to: view)
        cam = SKCameraNode()
        camera = cam
        addChild(cam)
        cam.zPosition = 100
    
        headsUpDisplay.name = "HeadsUpDisplay"
        scene?.camera?.addChild(headsUpDisplay)
        headsUpDisplay.zRotation = CGFloat(Double.pi/4)
        
        guard let gamestartup = GameStartup().readyPlayerOne(self) else { return }
        
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
        //tractor.addGlow()
        
        if let bombBtn = gamestartup.bombsbutton {
            bombsbutton = bombBtn
        }
        
        firebutton = gamestartup.firebutton
        bombsbutton2 = gamestartup.bombsbutton2
        firebutton2 = gamestartup.firebutton2
        
        (level, highlevel, score, highscore, lives) = GameStartup().loadScores()
        
        world = childNode(withName: "world")
                
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
        if let _ = GameScene(fileNamed: filename), let section = SKReferenceNode(fileNamed: filename)  {
                self.scene?.addChild(section)
                section.position = CGPoint(x:0,y:0)
                
                skView.isPaused = true
                
                if let level = section.children.first?.children {
                    //No longer hard encoded
                    for land in level {
                        
                        if let name = land.name {
                            if let midsection = section.childNode(withName: "//" + name ) as? SKTileMapNode {
                                
                                if name != "Water" {
                                    self.setupLevel( tileMap: midsection)
                                } else {
                                    land.alpha = 0.4
                                    land.zPosition = 1000
                                }
                            }
                        }
                    }
                }
                
                skView.isPaused = false
             
        } else {
            print("//*** Level not found: \(filename) ***//")
        }
        
        ParaStartup()
        
        for node in self.children {
            if (node.name == "world") {
                
                //Texture Map Node Stuff goes here
                for node in node.children {

                    if(node.name == "Rocky") {
                        rockBounds = node.frame
                        
                        scene?.physicsWorld.gravity = CGVector(dx: 0.0, dy: -3) //mini
                        scene?.physicsWorld.contactDelegate = self
                        scene?.physicsBody = SKPhysicsBody(edgeLoopFrom: rockBounds)
                        
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
                        
                        if  let x = scene?.frame.origin.x,
                            let y = scene?.frame.origin.y,
                            let w = scene?.frame.width ,
                        	let h = scene?.frame.height {
                            
                            let laserBounds = CGRect(x: x - 5, y: y, width: w + 10, height: h)
                            node.physicsBody = SKPhysicsBody(edgeLoopFrom: laserBounds )
                        }
                    
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
            
            
            
        if let bp : SKNode? = SKNode() {
            
            let texture = SKTexture(imageNamed: background)
            let width = texture.size().width
            let rounded = Int(round( rockBounds.width / width ))
            
            for i in -rounded...rounded  {
                let sprite = SKSpriteNode(texture: texture)
                sprite.position = CGPoint(x: CGFloat(i) * width, y: 0)
                bp?.addChild(sprite)
                bp?.zPosition = -243
            }
            
            backParalax = bp
            scene?.addChild(backParalax!)

            
        }
        
            
               
        
    	
        
        self.childNode(withName: "world")?.speed = 1.0
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
            let c = canape,
            let bp = backParalax
            else
        { return }
        
        //camera node x position = hero's
        cam.position.x = h.position.x
        
        //canape and hero have the same rotation
        c.zRotation = h.zRotation
        
        // adds depth to the scene
        // by moving the backgorund slower
        bp.position.x = cam.position.x * 0.334
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
                    GameProjectiles(laserbeak: laserbeam, scene: self, hero: (hero.position, hero.zRotation, heroVelocity), reverse:false ).firebomb(firebomb: firebutton)
                }
                
                if name == "fire-left" {
                    GameProjectiles(laserbeak: laserbeam, scene: self, hero: (hero.position, hero.zRotation, heroVelocity), reverse:true ).firebomb(firebomb: firebutton2)
                }
                
                if name == "fire-down" {
                    GameProjectiles(bombsaway: laserbeam, scene: self, hero: (hero.position, hero.zRotation, heroVelocity), reverse: false).firebomb(firebomb: bombsbutton)
                }
                
                if name == "fire-top" {
                    GameProjectiles(bombsaway: laserbeam, scene: self, hero: (hero.position, hero.zRotation, heroVelocity), reverse:true ).firebomb(firebomb: bombsbutton2)
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
                
                let rot = SKAction.rotate(toAngle: 0.0, duration: 0.08)
                hero.run(rot)
                hero.physicsBody?.linearDamping = CGFloat(40)
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
    
    func magicParticle (pos: CGPoint) {
        
        guard let smoke = SKEmitterNode(fileNamed: "magicParticle") else { return }
        
        let fadeToZero = SKAction.fadeAlpha(to: 0.0, duration:TimeInterval(2.0))
        let removeFromParent = SKAction.removeFromParent()
        let destroyVaporDelay = SKAction.wait(forDuration: 2.0)
        smoke.run(SKAction.sequence([destroyVaporDelay,fadeToZero,removeFromParent]))
        smoke.position = pos
        smoke.speed = 5
        smoke.zPosition = 150
        scene?.addChild(smoke)
        
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
                starPlayrOneLevelUpX(world:world!, moving:moving, scene: self, hero:hero, tractor:tractor)
            
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
        if let pad = cam.childNode(withName: "ArcadeJoyPad"), let hud = cam.childNode(withName: "HeadsUpDisplay")  {
            pad.removeFromParent()
            hud.removeAllChildren()
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
                    
                    guard let gamestartup = GameStartup().readyPlayerOne(self) else { return }
                    
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
            supermanLaser = true
                        
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
            trident = true

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
            GameStartup().saveScores(level: self.level, highlevel: self.highlevel, score: self.score, hscore:self.highscore, lives: self.lives)
        }
    }
 }
 
 
 extension SKSpriteNode {
    func addGlowX(radius: Float = 16) {
        let effectNode = SKEffectNode()
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.filter = CIFilter(name: "CIMotionBlur", parameters: ["inputRadius":radius,"inputAngle":CGFloat.pi/2])
        effectNode.shouldRasterize = true
        addChild(effectNode)
    }
 }

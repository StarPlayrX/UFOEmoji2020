//
//  GameMenu.swift
//  UF Emoji
//
//  Created by todd on 12/3/15.
//  Copyright (c) 2015 Todd Bruss. All rights reserved.
//

import SpriteKit
import AVFoundation

typealias appsettings =  (level: Int, highlevel: Int, emoji: Int, score: Int, highscore: Int, lives: Int, music: Bool, sound: Bool, stick: Bool, mode: Int)
var settings : appsettings = (level: 1, highlevel: 9, emoji: 1, score: 0, highscore: 0, lives: 3, music: true, sound: true, stick: true, mode: 0)

var levelarray: Array = ["🦕","🦕","🦎","🐢","🦋", "📡", "🕊","🦆","🍀","🐯", "🧟‍♀️", "🐿","💐","🦄","🐴","🐶","💐","🐌","🐄","🐄"]
var antiarray : Array = ["🦖","🦖","🐊","🐇","🐛", "🛰", "🐍","🦅","🎱","🦁", "🧟‍♂️", "🦔","🍄","🐺","🐗","🐱","🍄","🦂","🐓","🐓"]

var heroArray: Array = ["👽","👽","🐵","💩","👾"]
var heroDisplay: Array = ["🛸👽","🛸👽","🚀🐵","🚀💩","👾"]
var livesDisplay = ["", "👽","👽👽","👽👽👽","👽👽👽👽","👽👽👽👽👽","👽👽👽👽👽👽","👽👽👽👽👽👽👽",
                "👽👽👽👽👽👽👽👽", "👽👽👽👽👽👽👽👽👽", "👽👽👽👽👽👽👽👽👽👽"]

var maxlevel = 10
var doublelaser = 0
var trident = false
var shield = false
var supermanLaser = false

var KingQueenGlobalDie = 100

class GameMenu: SKScene {
    var minlevel = 1
    var maxEmoji = 3
    var minEmoji = 1
    var musicLabel: SKLabelNode = SKLabelNode(fontNamed: "Apple Color Emoji")
    var soundLabel: SKLabelNode = SKLabelNode(fontNamed: "Apple Color Emoji")
    var stickLabel: SKLabelNode = SKLabelNode(fontNamed: "Apple Color Emoji")
    var levelLabel: SKLabelNode = SKLabelNode(fontNamed: "Apple Color Emoji")
    var versusLabel: SKLabelNode = SKLabelNode(fontNamed: "Apple Color Emoji")
    var emojiLabel: SKLabelNode = SKLabelNode(fontNamed: "Apple Color Emoji")
    var playLabel1: SKLabelNode = SKLabelNode(fontNamed: "Apple Color Emoji")
    var playLabel2: SKLabelNode = SKLabelNode(fontNamed: "Apple Color Emoji")
    var playNode = SKNode()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        if settings.highlevel > maxlevel {
            settings.highlevel = maxlevel
        }
        
        
        
        super.touchesBegan(touches as Set<UITouch>, with: event)
        for touch: AnyObject in touches {
            let location: CGPoint = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if let name = touchedNode.name
            {
               // print(touchedNode as Any)
 
                if name == "music-left" || name == "music-right" || name == "musicLabel"{
                    settings.music = !settings.music //toggle
                    musicLabel.text =  settings.music  ? "🎷🔈" : "🎷🔇"
                }
                
                if name == "sound-left" || name == "sound-right" || name == "soundLabel"{
                    settings.sound = !settings.sound
                    soundLabel.text = settings.sound ? "💥🔔" : "💥🔕"
                }
                
                
                if name == "stick-left" || name == "stick-right" || name == "stickLabel"{
                    settings.stick = !settings.stick
                    stickLabel.xScale = settings.stick ? -1 : 1
                }
                
                if name == "level-right" || name == "levelLabel" || name == "versusLabel" {
                    if settings.level <= settings.highlevel {
                        settings.level = settings.level + 1
                    }
                    
                    if settings.level  <= settings.highlevel  {
                        levelLabel.text = levelarray[settings.level]
                        versusLabel.text = antiarray[settings.level ]
                    } else {
                        settings.level  = minlevel
                        levelLabel.text = levelarray[settings.level]
                        versusLabel.text = antiarray[settings.level ]
                    }
                }
                
                
                if name == "level-left" {
                    if settings.level >= minlevel {
                        settings.level = settings.level - 1
                    }
                    
                    if settings.level >= minlevel  {
                        levelLabel.text = levelarray[settings.level]
                        versusLabel.text = antiarray[settings.level ]
                    } else {
                        settings.level =  settings.highlevel
                        levelLabel.text = levelarray[settings.level]
                        versusLabel.text = antiarray[settings.level ]
                    }
                }
                
                
                if name == "emo-right" || name == "emojiLabel"{
                    if settings.emoji <= maxEmoji {
                        settings.emoji = settings.emoji + 1
                    }
                    
                    if settings.emoji  <= maxEmoji  {
                        emojiLabel.text = heroDisplay[settings.emoji ]
                        
                        playLabel1.text = heroArray[settings.emoji ]

                    } else {
                        settings.emoji  = minEmoji
                        emojiLabel.text = heroDisplay[settings.emoji ]
                        
                        playLabel1.text = heroArray[settings.emoji ]

                    }
                }
                
                if name == "emo-left" {
                    if settings.emoji >= minEmoji {
                        settings.emoji = settings.emoji - 1
                     }
                    
                    if settings.emoji >= minEmoji  {
                        emojiLabel.text = heroDisplay[settings.emoji]
                        
                        playLabel1.text = heroArray[settings.emoji ]

                    } else {
                        settings.emoji = maxEmoji
                        emojiLabel.text = heroDisplay[settings.emoji]
                        
                        playLabel1.text = heroArray[settings.emoji ]

                    }
                }

                if name == "play" {
                    
                    if settings.highlevel > maxlevel {
                        settings.highlevel = maxlevel
                    }
                    
                    if settings.level == 0 {
                        settings.level = 1
                    }
                    saveGameSettings()

                    if settings.emoji == 2 {
                        livesDisplay = ["", "🐵","🐵🐵","🐵🐵🐵","🐵🐵🐵🐵","🐵🐵🐵🐵🐵","🐵🐵🐵🐵🐵🐵",
                                        "🐵🐵🐵🐵🐵🐵🐵","🐵🐵🐵🐵🐵🐵🐵🐵","🐵🐵🐵🐵🐵🐵🐵🐵🐵", "🐵🐵🐵🐵🐵🐵🐵🐵🐵🐵"]
                    } else {
                        livesDisplay = ["", "👽","👽👽","👽👽👽","👽👽👽👽","👽👽👽👽👽","👽👽👽👽👽👽","👽👽👽👽👽👽👽",
                                        "👽👽👽👽👽👽👽👽", "👽👽👽👽👽👽👽👽👽", "👽👽👽👽👽👽👽👽👽👽"]
                    }
                    
                    let runcode = SKAction.run {
                        startUp(self)
                    }
                    
                    let fadeIn = SKAction.fadeAlpha(to: 0.5, duration:TimeInterval(0.3))
                    let myDecay = SKAction.wait(forDuration: 0.2)
                    let fadeOut = SKAction.fadeAlpha(to: 1.0, duration:TimeInterval(0.3))
                    
                    print("level:" + String(settings.level))
                    playNode.run(SKAction.sequence([fadeIn,myDecay,fadeOut,runcode]))

                } else if name != "musicLabel" && name != "soundLabel" && name != "stickLabel" && name != "levelLabel" && name != "versusLabel" && name != "emojiLabel" {
                    let fadeIn = SKAction.fadeAlpha(to: 0.5, duration:TimeInterval(0.1))
                    let myDecay = SKAction.wait(forDuration: 0.1)
                    let fadeOut = SKAction.fadeAlpha(to: 0.25, duration:TimeInterval(0.1))
                    touchedNode.run(SKAction.sequence([fadeIn,myDecay,fadeOut]))
                }
            }
        }
    }
    
    override func didMove(to view: SKView) {
        KingQueenGlobalDie = 100

        
        loadGameSettings()
        
        if settings.level > maxlevel {
            settings.level = 1
            settings.highlevel = 9
            saveGameSettings();
            
        }
        settings.highlevel = 10 //cheat to get all levels available
        saveGameSettings();
        
        //print(settings)
        settings.lives = 5; // may be less when power ups are added
        settings.score = 0;
    
        saveGameSettings();
        
        musicLabel.text =  settings.music  ? "🎷🔈" : "🎷🔇"
        soundLabel.text =  settings.sound ? "💥🔔" : "💥🔕"
        stickLabel.text =  "👉🕹"
        
        stickLabel.xScale = settings.stick ? -1 : 1
        levelLabel.text = levelarray[settings.level]
        versusLabel.text = antiarray[settings.level]
        
        //Put this into an Array and Loop Later -tb
        
        //Emoji Button
        //Left
        defineSprite (
            texture: "menu-left",
            scene: self,
            name: "emo-left",
            zPosition: 10,
            alpha: 0.25,
            speed: 0,
            alphaThreshold: 0
            ).drawHud(emojiLabel: emojiLabel, musicLabel: musicLabel, soundLabel: soundLabel, stickLabel: stickLabel, levelLabel: levelLabel, versusLabel: versusLabel,
                      playLabel1: playLabel1, playLabel2: playLabel2, playNode: playNode)
        
        //Emoji Button
        //Right
        defineSprite (
            texture: "menu-right",
            scene: self,
            name: "emo-right",
            zPosition: 10,
            alpha: 0.25,
            speed: 0,
            alphaThreshold: 0
            ).drawHud(emojiLabel: emojiLabel, musicLabel: musicLabel, soundLabel: soundLabel, stickLabel: stickLabel, levelLabel: levelLabel, versusLabel: versusLabel,
                      playLabel1: playLabel1, playLabel2: playLabel2, playNode: playNode)
        
        //Ship Button
        //Left
        defineSprite (
            texture: "menu-left",
            scene: self,
            name: "stick-left",
            zPosition: 10,
            alpha: 0.25,
            speed: 0,
            alphaThreshold: 0
            ).drawHud(emojiLabel: emojiLabel, musicLabel: musicLabel, soundLabel: soundLabel, stickLabel: stickLabel, levelLabel: levelLabel, versusLabel: versusLabel,
                      playLabel1: playLabel1, playLabel2: playLabel2, playNode: playNode)
        //Ship Button
        //Right
        defineSprite (
            texture: "menu-right",
            scene: self,
            name: "stick-right",
            zPosition: 10,
            alpha: 0.25,
            speed: 0,
            alphaThreshold: 0
            ).drawHud(emojiLabel: emojiLabel, musicLabel: musicLabel, soundLabel: soundLabel, stickLabel: stickLabel, levelLabel: levelLabel, versusLabel: versusLabel,
                      playLabel1: playLabel1, playLabel2: playLabel2, playNode: playNode)
        //Level Button
        //Left
        defineSprite (
            texture: "menu-left",
            scene: self,
            name: "level-left",
            zPosition: 10,
            alpha: 0.25,
            speed: 0,
            alphaThreshold: 0
            ).drawHud(emojiLabel: emojiLabel, musicLabel: musicLabel, soundLabel: soundLabel, stickLabel: stickLabel, levelLabel: levelLabel, versusLabel: versusLabel,
                      playLabel1: playLabel1, playLabel2: playLabel2, playNode: playNode)
        //Level Button
        //Right
        defineSprite (
            texture: "menu-right",
            scene: self,
            name: "level-right",
            zPosition: 10,
            alpha: 0.25,
            speed: 0,
            alphaThreshold: 0
            ).drawHud(emojiLabel: emojiLabel, musicLabel: musicLabel, soundLabel: soundLabel, stickLabel: stickLabel, levelLabel: levelLabel, versusLabel: versusLabel,
                      playLabel1: playLabel1, playLabel2: playLabel2, playNode: playNode)
        
        //Music Button
        //Left
        defineSprite (
            texture: "menu-left",
            scene: self,
            name: "music-left",
            zPosition: 10,
            alpha: 0.25,
            speed: 0,
            alphaThreshold: 0
            ).drawHud(emojiLabel: emojiLabel, musicLabel: musicLabel, soundLabel: soundLabel, stickLabel: stickLabel, levelLabel: levelLabel, versusLabel: versusLabel,
                      playLabel1: playLabel1, playLabel2: playLabel2, playNode: playNode)
        //Music Button
        //Right
        defineSprite (
            texture: "menu-right",
            scene: self,
            name: "music-right",
            zPosition: 10,
            alpha: 0.25,
            speed: 0,
            alphaThreshold: 0
            ).drawHud(emojiLabel: emojiLabel, musicLabel: musicLabel, soundLabel: soundLabel, stickLabel: stickLabel, levelLabel: levelLabel, versusLabel: versusLabel,
                      playLabel1: playLabel1, playLabel2: playLabel2, playNode: playNode)
        //Sound Button
        //Left
        defineSprite (
            texture: "menu-left",
            scene: self,
            name: "sound-left",
            zPosition: 10,
            alpha: 0.25,
            speed: 0,
            alphaThreshold: 0
            ).drawHud(emojiLabel: emojiLabel, musicLabel: musicLabel, soundLabel: soundLabel, stickLabel: stickLabel, levelLabel: levelLabel, versusLabel: versusLabel,
                      playLabel1: playLabel1, playLabel2: playLabel2, playNode: playNode)
        //Sound Button
        //Right
        defineSprite (
            texture: "menu-right",
            scene: self,
            name: "sound-right",
            zPosition: 10,
            alpha: 0.25,
            speed: 0,
            alphaThreshold: 0
            ).drawHud(emojiLabel: emojiLabel, musicLabel: musicLabel, soundLabel: soundLabel, stickLabel: stickLabel, levelLabel: levelLabel, versusLabel: versusLabel,
                      playLabel1: playLabel1, playLabel2: playLabel2, playNode: playNode)
        //Play Button
        //Awesome
        defineSprite (
            texture: "playbutton",
            scene: self,
            name: "play",
            zPosition: 10,
            alpha: 0.25,
            speed: 0,
            alphaThreshold: 0
            ).drawHud(emojiLabel: emojiLabel, musicLabel: musicLabel, soundLabel: soundLabel, stickLabel: stickLabel, levelLabel: levelLabel, versusLabel: versusLabel,
                      playLabel1: playLabel1, playLabel2: playLabel2, playNode: playNode)
        
        
    }
    
    //MARK: Sprites
    struct defineSprite {
        let texture: String
        let scene: SKScene
        let name: String
        let zPosition:CGFloat
        let alpha:CGFloat
        let speed:CGFloat
        let alphaThreshold: Float
        
        func drawHud( emojiLabel: SKLabelNode, musicLabel: SKLabelNode, soundLabel: SKLabelNode, stickLabel: SKLabelNode, levelLabel: SKLabelNode, versusLabel: SKLabelNode,
                      playLabel1: SKLabelNode, playLabel2: SKLabelNode, playNode: SKNode )  {
            let sprite = SKSpriteNode(imageNamed: texture)
            let spc = CGFloat(100)
            
            sprite.alpha = alpha;

            if name == "emo-left" {
                sprite.position =  (scene.childNode(withName: "emoji")?.position)!
                sprite.position.x = sprite.position.x - spc
                emojiLabel.fontSize = 48
                emojiLabel.name = "emojiLabel"
                //label.fontColor = SKColor.white
                emojiLabel.horizontalAlignmentMode = .center
                emojiLabel.verticalAlignmentMode = .center
                emojiLabel.position = (scene.childNode(withName: "emoji")?.position)!
                scene.addChild(emojiLabel)
            }
            
            if name == "emo-right" {
                sprite.position =  (scene.childNode(withName: "emoji")?.position)!
                sprite.position.x = sprite.position.x + spc
            }
            
            if name == "stick-left" {
                sprite.position =  (scene.childNode(withName: "ship")?.position)!
                sprite.position.x = sprite.position.x - spc
                
                stickLabel.name = "stickLabel"
                stickLabel.fontSize = 48
                stickLabel.horizontalAlignmentMode = .center
                stickLabel.verticalAlignmentMode = .center
                stickLabel.position = (scene.childNode(withName: "ship")?.position)!
                stickLabel.position.y = stickLabel.position.y
                scene.addChild(stickLabel)
            }
    
            if name == "stick-right" {
                sprite.position =  (scene.childNode(withName: "ship")?.position)!
                sprite.position.x = sprite.position.x + spc
            }
            
            if name == "level-left" {
                sprite.position =  (scene.childNode(withName: "level")?.position)!
                sprite.position.x = sprite.position.x - spc
                
                levelLabel.name = "levelLabel"
                levelLabel.fontSize = 48
                levelLabel.horizontalAlignmentMode = .center
                levelLabel.verticalAlignmentMode = .center
                levelLabel.position = (scene.childNode(withName: "level")?.position)!
                levelLabel.position.x = levelLabel.position.x - 28
                levelLabel.xScale = levelLabel.xScale * -1
                levelLabel.zPosition = 100

                scene.addChild(levelLabel)
                
                /*
                let magic = SKEmitterNode(fileNamed: "magicParticle")!
                magic.position = (scene.childNode(withName: "level")?.position)!
                magic.position.x = levelLabel.position.x
                magic.position.y = magic.position.y - 5

                magic.alpha = 0.1
                magic.zPosition = 90
                scene.addChild(magic)
                */
                
                
                versusLabel.name = "versusLabel"
                versusLabel.fontSize = 48
                versusLabel.horizontalAlignmentMode = .center
                versusLabel.verticalAlignmentMode = .center
                versusLabel.position = (scene.childNode(withName: "level")?.position)!
                versusLabel.position.x = versusLabel.position.x + 28
                versusLabel.zPosition = 100
                
                /*
                let smoke = SKEmitterNode(fileNamed: "smokeParticle")!
                smoke.position = (scene.childNode(withName: "level")?.position)!
                smoke.position.x = versusLabel.position.x
                smoke.position.y = smoke.position.y - 5
                
                smoke.alpha = 0.1
                smoke.zPosition = 90
                
                scene.addChild(smoke)
                */
                scene.addChild(versusLabel)
            }
            
            if name == "level-right" {
                sprite.position =  (scene.childNode(withName: "level")?.position)!
                sprite.position.x = sprite.position.x + spc
            }
            
            if name == "music-left" {
                sprite.position =  (scene.childNode(withName: "music")?.position)!
                sprite.position.x = sprite.position.x - spc
                
                musicLabel.name = "musicLabel"
                musicLabel.fontSize = 48
                musicLabel.horizontalAlignmentMode = .center
                musicLabel.verticalAlignmentMode = .center
                musicLabel.position = (scene.childNode(withName: "music")?.position)!
                musicLabel.position.y = musicLabel.position.y
                scene.addChild(musicLabel)
            }
            
            if name == "music-right" {
                sprite.position =  (scene.childNode(withName: "music")?.position)!
                sprite.position.x = sprite.position.x + spc
            }
            
            if name == "sound-left" {
                sprite.position =  (scene.childNode(withName: "sound")?.position)!
                sprite.position.x = sprite.position.x - spc
                
                soundLabel.name = "soundLabel"
                soundLabel.fontSize = 48
                soundLabel.horizontalAlignmentMode = .center
                soundLabel.verticalAlignmentMode = .center
                soundLabel.position = (scene.childNode(withName: "sound")?.position)!
                soundLabel.position.y = soundLabel.position.y
                scene.addChild(soundLabel)}
            
            if name == "sound-right" {
                sprite.position =  (scene.childNode(withName: "sound")?.position)!
                sprite.position.x = sprite.position.x + spc
            }
            
            if name == "play" {
                
                //🤾‍♀️🏏⚽️⚾️
                scene.addChild(playNode)
                playNode.position =  (scene.childNode(withName: name)?.position)!
                playNode.position.x = playNode.position.x + spc - 16

                let playLabel = SKLabelNode(fontNamed: "Apple Color Emoji")
                playLabel.text = "🎮"
                playLabel.fontSize = 48
                playLabel.horizontalAlignmentMode = .center
                playLabel.verticalAlignmentMode = .center
                playLabel.name = name
                playLabel.position = CGPoint(x:(-spc * 1.5) - 33,y:0)
                playNode.addChild(playLabel)

                
               // playLabel1.position = sprite.position
                playLabel1.text = heroArray[settings.emoji ]
                playLabel1.fontSize = 48
                playLabel1.horizontalAlignmentMode = .center
                playLabel1.verticalAlignmentMode = .center
                playLabel1.name = name
                
                //playLabel2.position = sprite.position

                playLabel2.text = "🌎"
                playLabel2.fontSize = 44
                playLabel2.horizontalAlignmentMode = .center
                playLabel2.verticalAlignmentMode = .center
                playLabel2.alpha = 1.0
                playLabel2.name = name
                
                let subtext = SKLabelNode(fontNamed: "Emulogic")
                
                subtext.text = ""
                subtext.fontSize = 32
                subtext.horizontalAlignmentMode = .center
                subtext.verticalAlignmentMode = .center
                subtext.name = name
                subtext.zPosition = 101
                subtext.alpha = 0.5
                subtext.fontColor = UIColor.white
                playNode.addChild(subtext)
                subtext.position = CGPoint(x:-(spc / 2) - 19.25,y:1.5)
               
                
            }
            
            //sprite.zPosition = 200
            sprite.alpha = alpha
            sprite.name = name
            
            
            if name == "play" {
                playNode.addChild(sprite)
                sprite.position = CGPoint(x:0,y:0)
                playNode.addChild(playLabel1)
                playNode.addChild(playLabel2)
                playLabel1.position = CGPoint(x:-spc - 27,y:0)
                playLabel2.position = CGPoint(x:-(spc / 2) - 20,y:0)

            } else {
                scene.addChild(sprite)
            }
            
            levelLabel.text = levelarray[settings.level ]
            versusLabel.text = antiarray[settings.level ]
            emojiLabel.text = heroDisplay[settings.emoji]
            playLabel1.text = heroArray[settings.emoji ]

        }
    }
}


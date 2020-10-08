//
//  Global.swift
//  UFO Emoji
//
//  Created by Todd Bruss on 5/24/20.
//  Copyright © 2020 Todd Bruss. All rights reserved.
//

//Maybe move this to a Setting class

import SpriteKit

typealias appsettings =  (level: Int, highlevel: Int, emoji: Int, score: Int, highscore: Int, lives: Int, music: Bool, sound: Bool, stick: Bool, mode: Int)
var settings : appsettings = (level: 1, highlevel: 10, emoji: 1, score: 0, highscore: 0, lives: 6, music: true, sound: true, stick: true, mode: 0)

var levelarray: Array = ["🦕","🦕","🦎","🚙","🦋", "🐮", "🕊","🦆","🍀","🕸", "🥥", "🐿","💐","🦄","🐴","🐶","💐","🐌","🐄","🐄"]
var antiarray : Array = ["🦖","🦖","🐊","🚗","🐛", "🐔", "🐍","🦅","🎱","🕷", "🌴", "🦔","🍄","🐺","🐗","🐱","🍄","🦂","🐓","🐓"]

var heroArray: Array = ["👽","👽","🐵","💩","👾"]
var heroDisplay: Array = ["🛸👽","🛸👽","🚀🐵","🚀💩","👾"]
var livesDisplay = ["", "👽","👽👽","👽👽👽","👽👽👽👽","👽👽👽👽👽","👽👽👽👽👽👽","👽👽👽👽👽👽👽",
                    "👽👽👽👽👽👽👽👽", "👽👽👽👽👽👽👽👽👽", "👽👽👽👽👽👽👽👽👽👽"]

var maxlevel = 11
var doublelaser = 0
var 🔱 = false
var 🛡 = false
var 💠 = false
var 🕹 = false

var KingQueenGlobalDie = 100
var emojifontname = "Toddmoji" //"Segoe UI Emoji" //"EmojiOneColor"//     "Apple Color Emoji" //"Segoe UI Emoji"
var gameDelegate : GameProtocol?

let showsFPS = false
let showsNodeCount = false
let showsPhysics = false
let showsFields = false
let showsDrawCount = false
let showsQuadCount = false

func loadScores() -> (level: Int, highlevel: Int, score: Int, hscore: Int, lives: Int) {
    let hscore = settings.highscore
    let highlevel = settings.highlevel
    let score = settings.score
    let level = settings.level
    let lives = settings.lives
    return (level, highlevel, score, hscore, lives)
}

func saveScores(level: Int, highlevel: Int, score: Int, hscore: Int, lives: Int) {
    settings.highlevel = highlevel
    settings.score = score
    settings.level = level
    settings.highscore = hscore
    settings.lives = lives
}

func getDeviceSize() {
    // iPhone detection
    let screenWidth = Int(UIScreen.main.bounds.size.width)
    let screenHeight = Int(UIScreen.main.bounds.size.height)
    let screenMax = Int(max(screenWidth,screenHeight))
    
    let iPhone = screenMax == 568 || screenMax == 667 || screenMax == 736
    let iPhoneX = screenMax == 812 || screenMax == 896
    settings.mode = 1 // iPad
    
    if iPhone {
        settings.mode = 2
    } else if iPhoneX {
        settings.mode = 4
    }
}

func setSceneSizeForGame() -> CGSize  {
    
    getDeviceSize()
        

    //Put this in a common area
    if (settings.mode == 2 ) {
        //regular iPhone style
        return CGSize(width: 626, height: 352)
        
    } else if (settings.mode == 4) {
        // iPhone X style
        return CGSize(width: 762, height: 352)
        
    } else {
        
        let screenWidth = CGFloat(UIScreen.main.bounds.size.width)
        let screenHeight = CGFloat(UIScreen.main.bounds.size.height)
        let screenMax = CGFloat(max(screenWidth,screenHeight))
        let screenMin = CGFloat(min(screenWidth,screenHeight))
        
        return CGSize(width: 470,  height: 470 * ( screenMin / screenMax ) )
    }
}


func setSceneSizeForMenu() -> CGSize  {
    
    getDeviceSize()
        

    //Put this in a common area
    if (settings.mode == 2 ) {
        //regular iPhone style
        return CGSize(width: 626, height: 352)
        
    } else if (settings.mode == 4) {
        // iPhone X style
        return CGSize(width: 762, height: 352)
        
    } else {
        
        let screenWidth = CGFloat(UIScreen.main.bounds.size.width)
        let screenHeight = CGFloat(UIScreen.main.bounds.size.height)
        let screenMax = CGFloat(max(screenWidth,screenHeight))
        let screenMin = CGFloat(min(screenWidth,screenHeight))
        
        return CGSize(width: 600,  height: 600 * ( screenMin / screenMax ) )
    }
}
   
    
typealias Oreo = (bombsbutton:SKSpriteNode?,firebutton:SKSpriteNode?,hero:SKSpriteNode?,canape:SKSpriteNode?,tractor:SKSpriteNode?,bombsbutton2:SKSpriteNode?,firebutton2:SKSpriteNode?)

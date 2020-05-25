//
//  Global.swift
//  UFO Emoji
//
//  Created by Todd Bruss on 5/24/20.
//  Copyright © 2020 Todd Bruss. All rights reserved.
//

import Foundation
import SpriteKit

typealias appsettings =  (level: Int, highlevel: Int, emoji: Int, score: Int, highscore: Int, lives: Int, music: Bool, sound: Bool, stick: Bool, mode: Int)
var settings : appsettings = (level: 1, highlevel: 9, emoji: 1, score: 0, highscore: 0, lives: 1, music: true, sound: true, stick: true, mode: 0)

var levelarray: Array = ["🦕","🦕","🦎","🐢","🦋", "📡", "🕊","🦆","🍀","🐯", "🧟‍♀️", "🐿","💐","🦄","🐴","🐶","💐","🐌","🐄","🐄"]
var antiarray : Array = ["🦖","🦖","🐊","🐇","🐛", "🛰", "🐍","🦅","🎱","🦁", "🧟‍♂️", "🦔","🍄","🐺","🐗","🐱","🍄","🦂","🐓","🐓"]

var heroArray: Array = ["👽","👽","🐵","💩","👾"]
var heroDisplay: Array = ["🛸👽","🛸👽","🚀🐵","🚀💩","👾"]
var livesDisplay = ["", "👽","👽👽","👽👽👽","👽👽👽👽","👽👽👽👽👽","👽👽👽👽👽👽","👽👽👽👽👽👽👽",
                    "👽👽👽👽👽👽👽👽", "👽👽👽👽👽👽👽👽👽", "👽👽👽👽👽👽👽👽👽👽"]

var maxlevel = 10
var doublelaser = 0
var 🔱 = false
var shield = false
var 🔋 = false

var KingQueenGlobalDie = 100

///

protocol GameProtocol {
    func runGameMenu()
    func runGameLevel()
}

var gameDelegate : GameProtocol?


///




var headsUpDisplay = SKReferenceNode()
var maxVelocity = CGFloat(0)
var backParalax =  SKNode()


typealias Oreo =  (bombsbutton:SKSpriteNode?,firebutton:SKSpriteNode?,hero:SKSpriteNode?,canape:SKSpriteNode?,tractor:SKSpriteNode?,bombsbutton2:SKSpriteNode?,firebutton2:SKSpriteNode?)


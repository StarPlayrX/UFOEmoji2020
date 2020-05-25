//
//  GameSettings.swift
//  UF Emoji
//
//  Created by Todd Bruss on 4/4/17.
//  Copyright © 2017 Todd Bruss. All rights reserved.
//

import UIKit
import SpriteKit

class GameSettings: NSObject, NSCoding {
    
    let level:      Any
    let highlevel:  Any
    let emoji:      Any
    let score:      Any
    let highscore:  Any
    let lives:      Any
    let music:      Any
    let sound:      Any
    let stick:      Any
    let mode:       Any
    
    init(level: Any, highlevel: Any, emoji: Any, score: Any, highscore: Any, lives: Any, music: Any, sound: Any, stick: Any, mode: Any) {
        self.level      = level
        self.highlevel  = highlevel
        self.emoji      = emoji
        self.score      = score
        self.highscore  = highscore
        self.lives      = lives
        self.music      = music
        self.sound      = sound
        self.stick      = stick
        self.mode       = mode
    }
    
    // MARK: NSCoding
    public convenience required init?(coder aDecoder: NSCoder) {
        
        let level       = aDecoder.decodeObject(forKey: "level")
        let highlevel   = aDecoder.decodeObject(forKey: "highlevel")
        let emoji       = aDecoder.decodeObject(forKey: "emoji")
        let score       = aDecoder.decodeObject(forKey: "score")
        let highscore   = aDecoder.decodeObject(forKey: "highscore")
        let lives       = aDecoder.decodeObject(forKey: "lives")
        let music       = aDecoder.decodeObject(forKey: "music")
        let sound       = aDecoder.decodeObject(forKey: "sound")
        let stick       = aDecoder.decodeObject(forKey: "stick")
        let mode        = aDecoder.decodeObject(forKey: "mode")
        self.init(level: level!, highlevel: highlevel!, emoji: emoji!, score: score!, highscore: highscore!, lives: lives!, music: music!, sound: sound!, stick: stick!, mode: mode!)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(level,        forKey: "level")
        aCoder.encode(highlevel,    forKey: "highlevel")
        aCoder.encode(emoji,        forKey: "emoji")
        aCoder.encode(score,        forKey: "score")
        aCoder.encode(highscore,    forKey: "highscore")
        aCoder.encode(lives,        forKey: "lives")
        aCoder.encode(music,        forKey: "music")
        aCoder.encode(sound,        forKey: "sound")
        aCoder.encode(stick,        forKey: "stick")
        aCoder.encode(mode,         forKey: "mode")
    }
}

// We first of all create a class that can be initialized using an NSCoder instance and encode itself into an instance of NSCoder. And once we have this functionality, which is required by the NSCoding protocol, it is possible to create an instance that can be archived

func saveGameSettings() {
    //print("Saving:")
    //print(settings)
    let s = GameSettings(level: settings.level, highlevel: settings.highlevel, emoji: settings.emoji, score: settings.score, highscore: settings.highscore, lives: settings.lives, music: settings.music, sound: settings.sound, stick: settings.stick, mode: settings.mode)    
    let filePath = try! FileSave.buildPath(path: "ufemoji", inDirectory: FileManager.SearchPathDirectory.cachesDirectory, subdirectory: "ufemoji")
    NSKeyedArchiver.archiveRootObject(s, toFile: filePath)
    //try! NSKeyedArchiver.archivedData(withRootObject: s, requiringSecureCoding: false)
    //print(s)
}



func loadGameSettings() {
    //print("Loading:")

    let filePath = FileLoad.buildPath(path: "ufemoji", inDirectory: FileManager.SearchPathDirectory.cachesDirectory, subdirectory: "ufemoji")
    if let s = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? GameSettings {
        settings = (level: s.level as! Int, highlevel: s.highlevel as! Int, emoji: s.emoji as! Int, score: s.score as! Int, highscore: s.highscore as! Int, lives: s.lives as! Int, music: s.music as! Bool, sound: s.sound as! Bool, stick: s.stick as! Bool, mode: s.mode as! Int)
    }
   // print(settings)
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
        //Previous iPhones
        settings.mode = 2
    } else if iPhoneX {
        //iPhone Ten
        settings.mode = 4
    }
}



func setSceneSizeForGame() -> CGSize  {
     loadGameSettings()
    
     getDeviceSize()
    
    //Put this in a common area
    if (settings.mode == 2 ) {
        //regular iPhone style
        return CGSize(width: 626, height: 352)
        
    } else if (settings.mode == 4) {
        // iPhone X style
        return CGSize(width: 762, height: 352)
        
    } else {
        return CGSize(width: 470, height: 352)
    }
}

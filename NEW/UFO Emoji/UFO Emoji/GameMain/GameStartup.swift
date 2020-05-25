//
//  GameStartup.swift
//  UF Emoji
//
//  Created by todd on 12/3/15.
//  Copyright © 2015 Todd Bruss. All rights reserved.
//

class GameStartup {
    
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
        saveGameSettings()
    }

}

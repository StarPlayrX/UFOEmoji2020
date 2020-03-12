//
//  FileDirectory.swift
//
//  The MIT License (MIT)
//  Created by Anthony Levings on 25/06/2014.
//  Swift 2-4 Updates and adaptation by Todd Bruss 11/15/2017

import Foundation

public struct FileDirectory {
    public static func applicationDirectory(directory:FileManager.SearchPathDirectory, subdirectory:String? = nil) -> NSURL? {
    
    if let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    {
        if let subD = subdirectory {
            return NSURL(fileURLWithPath:documentsDirectoryPath).appendingPathComponent(subD) as NSURL?
        }
        else {
            return NSURL(fileURLWithPath:documentsDirectoryPath)
        }
    }
    else {
     return nil
    }
}

public static func applicationTemporaryDirectory() -> NSURL? {
        let tD = NSTemporaryDirectory()
        return NSURL(string:tD)
    }
}

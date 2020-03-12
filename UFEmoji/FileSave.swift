//
//  FileSave.swift
//
//  The MIT License (MIT)
//  Created by Anthony Levings on 25/06/2014.
//  Swift 2-4 Updates and adaptation by Todd Bruss 11/15/2017

import Foundation

public struct FileSave {

    public static func saveData(fileData:NSData, directory:FileManager.SearchPathDirectory, path:String, subdirectory:String?) throws -> Bool
    {
        let savePath = try buildPath(path: path, inDirectory: directory, subdirectory: subdirectory)
        let ok:Bool = FileManager.default.createFile(atPath: savePath,contents:fileData as Data, attributes:nil)
        return ok
    }
    
    public static func saveDataToTemporaryDirectory(fileData:NSData, path:String, subdirectory:String?) throws -> Bool
    {
        let savePath = try buildPathToTemporaryDirectory(path: path, subdirectory: subdirectory)
        let ok:Bool = FileManager.default.createFile(atPath: savePath,contents:fileData as Data, attributes:nil)
        return ok
    }
    
    public static func saveString(fileString:String, directory:FileManager.SearchPathDirectory, path:String, subdirectory:String) throws {
        let savePath = try buildPath(path: path, inDirectory: directory, subdirectory: subdirectory)
        try fileString.write(toFile: savePath, atomically:false, encoding:String.Encoding.utf8)
    }
    public static func saveStringToTemporaryDirectory(fileString:String, path:String, subdirectory:String) throws {
        let savePath = try buildPathToTemporaryDirectory(path: path, subdirectory: subdirectory)
        try fileString.write(toFile: savePath, atomically:false, encoding:String.Encoding.utf8)
    }
    
    public static func buildPath(path:String, inDirectory directory:FileManager.SearchPathDirectory, subdirectory:String?) throws -> String  {
        let newPath = FileHelper.stripSlashIfNeeded(stringWithPossibleSlash: path)
        var newSubdirectory:String?
        if let sub = subdirectory {
            newSubdirectory = FileHelper.stripSlashIfNeeded(stringWithPossibleSlash: sub)
        }
        var savePath = ""
        if let direct = FileDirectory.applicationDirectory(directory: directory),
            let path = direct.path {
                savePath = path + "/"
        }
        
        if (newSubdirectory != nil) {
            savePath = savePath.appending(newSubdirectory!)
            try FileHelper.createSubDirectory(subdirectoryPath: savePath)
            savePath += "/"
        }
        
        savePath += newPath
        
        return savePath
    }
    
    public static func buildPathToTemporaryDirectory(path:String, subdirectory:String?) throws -> String {
        // Remove unnecessary slash if need
        let newPath = FileHelper.stripSlashIfNeeded(stringWithPossibleSlash: path)
        var newSubdirectory:String?
        if let sub = subdirectory {
            newSubdirectory = FileHelper.stripSlashIfNeeded(stringWithPossibleSlash: sub)
        }
        
        var savePath = ""
        if let direct = FileDirectory.applicationTemporaryDirectory(),
            let path = direct.path {
                savePath = path + "/"
        }
        
        if let sub = newSubdirectory {
            savePath += sub
            try FileHelper.createSubDirectory(subdirectoryPath: savePath)
            savePath += "/"
        }
        
        savePath += newPath
        return savePath
    }
}

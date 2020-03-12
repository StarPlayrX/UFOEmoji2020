//
//  FileLoad.swift
//
//  The MIT License (MIT)
//  Created by Anthony Levings on 25/06/2014.
//  Swift 2-4 Updates and adaptation by Todd Bruss 11/15/2017


import Foundation

public struct FileLoad {
    
    
    public static func loadData(path:String, directory:FileManager.SearchPathDirectory, subdirectory:String?) -> NSData? {
        let loadPath = buildPath(path: path, inDirectory: directory, subdirectory: subdirectory)
        let data = FileManager.default.contents(atPath: loadPath)
        return data as NSData?
    }
    
    
    public static func loadDataFromTemporaryDirectory(path:String, subdirectory:String?) -> NSData? {
        let loadPath = buildPathToTemporaryDirectory(path: path, subdirectory: subdirectory)
        let data = FileManager.default.contents(atPath: loadPath)
        return data as NSData?
    }

    public static func loadString(path:String, directory:FileManager.SearchPathDirectory, subdirectory:String?, encoding enc:String.Encoding = String.Encoding.utf8) throws -> String? {
        let loadPath = buildPath(path: path, inDirectory: directory, subdirectory: subdirectory)
        let text:String? = try String(contentsOfFile:loadPath, encoding:enc)
        return text
    }
    
    
    public static func loadStringFromTemporaryDirectory(path:String, subdirectory:String?, encoding enc:String.Encoding = String.Encoding.utf8) throws -> String? {
        let loadPath = buildPathToTemporaryDirectory(path: path, subdirectory: subdirectory)
        let text:String? = try String(contentsOfFile:loadPath, encoding:enc)
        return text
    }
    
    public static func buildPath(path:String, inDirectory directory:FileManager.SearchPathDirectory, subdirectory:String?) -> String {
        let newPath = FileHelper.stripSlashIfNeeded(stringWithPossibleSlash: path)
        var subDir:String?
        if let sub = subdirectory {
            subDir = FileHelper.stripSlashIfNeeded(stringWithPossibleSlash: sub)
        }
        
        var loadPath = ""
        
        if let direct = FileDirectory.applicationDirectory(directory: directory),
            let path = direct.path {
                loadPath = path + "/"
        }
        
        if let sub = subDir {
            loadPath += sub
            loadPath += "/"
        }
        
        loadPath += newPath
        return loadPath
    }
    public static func buildPathToTemporaryDirectory(path:String, subdirectory:String?) -> String {
        let newPath = FileHelper.stripSlashIfNeeded(stringWithPossibleSlash: path)
        var subDir:String?
        if let sub = subdirectory {
            subDir = FileHelper.stripSlashIfNeeded(stringWithPossibleSlash: sub)
        }
        var loadPath = ""
        
        if let direct = FileDirectory.applicationTemporaryDirectory(),
            let path = direct.path {
                loadPath = path + "/"
        }
        if let sub = subDir {
            loadPath += sub
            loadPath += "/"
        }
        loadPath += newPath
        return loadPath
    }
}

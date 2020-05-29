//
//  FileHelper.swift
//
//  The MIT License (MIT)
//  Created by Anthony Levings on 25/06/2014.
//  Swift 2-4 Updates and adaptation by Todd Bruss 11/15/2017


import Foundation

public class FileHelper {
public static func stripSlashIfNeeded(stringWithPossibleSlash:String) -> String {
    var stringWithoutSlash:String = stringWithPossibleSlash
    // If the file name contains a slash at the beginning then we remove so that we don't end up with two
    if stringWithPossibleSlash.hasPrefix("/") {
        stringWithoutSlash = String(stringWithPossibleSlash.suffix(from: stringWithoutSlash.index(stringWithoutSlash.startIndex, offsetBy:1)))
    }
    // Return the string with no slash at the beginning
    return stringWithoutSlash
}

public static func createSubDirectory(subdirectoryPath:String) throws {
    
    var isDir:ObjCBool=false;
    let exists:Bool = FileManager.default.fileExists(atPath: subdirectoryPath, isDirectory:&isDir)
    if (exists) {
        /* a file of the same name exists, we don't care about this so won't do anything */
        if isDir.boolValue {
            /* subdirectory already exists, don't create it again */
            // FIXME: throw error
            return
        }
    }
    try FileManager.default.createDirectory(atPath: subdirectoryPath, withIntermediateDirectories:true, attributes:nil)    
    }
}

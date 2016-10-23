//
//  main.swift
//  Revolutionary Hello World
//
//  Created by Shiyu Du on 10/21/16.
//  Copyright © 2016 Shiyu Du. All rights reserved.
//

import Foundation

let manager = FileManager.default

let workingDirectoryPath = manager.urls(for: .cachesDirectory, in: .userDomainMask).first!.path.appending(pathComponent: "Revolutionary Hello World")
let defaultSourceFileName = "hello"
let swiftSourceExtension = "swift"

func getSourceFileName() -> String {
    var result = defaultSourceFileName
    var i = 0
    while manager.fileExists(atPath: workingDirectoryPath.appending(pathComponent: result)) {
        i += 1
        result = defaultSourceFileName + String(i)
    }
    
    return result
}

let sourceFileName = getSourceFileName()
let sourceFilePath = workingDirectoryPath.appending(pathComponent: sourceFileName.appending(pathExtension: swiftSourceExtension)!)
let executableFilePath = workingDirectoryPath.appending(pathComponent: sourceFileName)

do {
    print("Writing program source...")
    
    try "let name = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : \"world\"\nprint(\"Hello, \\(name)!\")".write(toFile: sourceFilePath, atomically: true, encoding: String.Encoding.utf8)
} catch {
    print(error.localizedDescription)
    exit(1)
}

launch("/usr/bin/xcrun", with: ["-sdk", "macosx", "swiftc", sourceFilePath, "-o", executableFilePath], from: workingDirectoryPath).waitUntilExit()

let args: [String]? = CommandLine.arguments.count > 1 ? CommandLine.arguments.removingFirst : nil
print("Running program: \(sourceFileName), with arguments: \((args ?? []).description))")
launch(executableFilePath, with: args).waitUntilExit()

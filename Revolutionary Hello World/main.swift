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

if !manager.fileExists(atPath: workingDirectoryPath) {
    do {
        try manager.createDirectory(atPath: workingDirectoryPath, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print(error.localizedDescription)
        exit(100)
    }
} else {
    do {
        let contents = try manager.contentsOfDirectory(atPath: workingDirectoryPath)
        for file in contents {
            try manager.removeItem(atPath: file)
        }
    } catch {
        print(error.localizedDescription)
        exit(100)
    }
}

let swiftSourceExtension = "swift"
let programName = "hello"
let sourceFilePath = workingDirectoryPath.appending(pathComponent: programName.appending(pathExtension: swiftSourceExtension)!)
let executableFilePath = workingDirectoryPath.appending(pathComponent: programName)

do {
    print("Writing program source...")
    
    try "let name = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : \"world\"\nprint(\"Hello, \\(name)!\")".write(toFile: sourceFilePath, atomically: true, encoding: String.Encoding.utf8)
} catch {
    print(error.localizedDescription)
    exit(1)
}

launch("/usr/bin/xcrun", with: ["-sdk", "macosx", "swiftc", sourceFilePath, "-o", executableFilePath], from: workingDirectoryPath).waitUntilExit()

let args: [String]? = CommandLine.arguments.count > 1 ? CommandLine.arguments.removingFirst : nil
print("Running program: \(programName), with arguments: \((args ?? []).description))")
launch(executableFilePath, with: args).waitUntilExit()

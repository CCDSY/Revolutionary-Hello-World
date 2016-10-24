//
//  main.swift
//  Revolutionary Hello World
//
//  Created by Shiyu Du on 10/21/16.
//  Copyright © 2016 Shiyu Du. All rights reserved.
//

import Foundation

let manager = FileManager.default

var workingDirectoryPath = manager.urls(for: .cachesDirectory, in: .userDomainMask).first!.path.appending(pathComponent: "Revolutionary Hello World")
if CommandLine.arguments.count > 1 {
    let workingDirectoryCandidateUrl = URL(fileURLWithPath: CommandLine.arguments[1])
    let workingDirectoryCandidatePath = workingDirectoryCandidateUrl.path
    if workingDirectoryCandidateUrl.hasDirectoryPath || !manager.fileExists(atPath: workingDirectoryCandidatePath) {
        workingDirectoryPath = workingDirectoryCandidatePath
    }
}

let swiftSourceExtension = "swift"
let programName = "hello"
let sourceFilePath = workingDirectoryPath.appending(pathComponent: programName.appending(pathExtension: swiftSourceExtension)!)
let executableFilePath = workingDirectoryPath.appending(pathComponent: programName)

let sourceText = "let name = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : \"world\"\nprint(\"Hello, \\(name)!\")"

do {
    if !manager.fileExists(atPath: workingDirectoryPath) {
        try manager.createDirectory(atPath: workingDirectoryPath, withIntermediateDirectories: true, attributes: nil)
    }
    
    if manager.fileExists(atPath: sourceFilePath) {
        try manager.removeItem(atPath: sourceFilePath)
    }
    if manager.fileExists(atPath: executableFilePath) {
        try manager.removeItem(atPath: executableFilePath)
    }
    
    print("Writing program source...")
    try sourceText.write(toFile: sourceFilePath, atomically: true, encoding: .utf8)
} catch {
    print(error)
    exit(100)
}

launch("/usr/bin/xcrun", with: ["-sdk", "macosx", "swiftc", sourceFilePath, "-o", executableFilePath], from: workingDirectoryPath).waitUntilExit()

let args: [String]? = CommandLine.arguments.count > 2 ? CommandLine.arguments.removingFirst(2) : nil
print("Running program: \(programName), with arguments: \((args ?? []).description))")
launch(executableFilePath, with: args).waitUntilExit()

do {
    try manager.removeItem(atPath: sourceFilePath)
    try manager.removeItem(atPath: executableFilePath)
} catch {
    print(error)
}

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
let debugBuildPath = ".build/debug/"
let sourcePath = "Sources/"
let defaultSourceFileName = "main.swift"
let defaultProjectName = "Hello"

func getProjectName() -> String {
    var result = defaultProjectName
    var i = 0
    while manager.fileExists(atPath: workingDirectoryPath.appending(pathComponent: result)) {
        i += 1
        result = defaultProjectName + String(i)
    }
    
    return result
}

let projectName = getProjectName()
let projectDirectoryPath = workingDirectoryPath.appending(pathComponent: projectName)

do {
    print("Creating package directory...")
    try FileManager.default.createDirectory(atPath: projectDirectoryPath, withIntermediateDirectories: true, attributes: nil)
} catch {
    print(error.localizedDescription)
    exit(100)
}

launch("/usr/bin/swift", with: ["package", "init", "--type", "executable"], from: projectDirectoryPath).waitUntilExit()

do {
    print("Writing program source...")
    
    try "let name = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : \"world\"\nprint(\"Hello, \\(name)!\")".write(toFile: projectDirectoryPath.appending(pathComponent: sourcePath).appending(pathComponent: defaultSourceFileName), atomically: false, encoding: String.Encoding.utf8)
} catch {
    print(error.localizedDescription)
    exit(1)
}

launch("/usr/bin/swift", with: ["build"], from: projectDirectoryPath).waitUntilExit()

let debugExecutablePath = projectDirectoryPath.appending(pathComponent: debugBuildPath).appending(pathComponent: projectName)
let args: [String]? = CommandLine.arguments.count > 1 ? CommandLine.arguments.removingFirst : nil
print("Running program: \(projectName), with arguments: \((args ?? []).description))")
launch(debugExecutablePath, with: args).waitUntilExit()

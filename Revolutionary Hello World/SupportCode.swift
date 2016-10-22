//
//  SupportCode.swift
//  Revolutionary Hello World
//
//  Created by CC on 10/22/16.
//  Copyright © 2016 Shiyu Du. All rights reserved.
//

import Foundation

extension Array {
    var removingFirst: [Element] {
        return Array(self[1 ..< count])
    }
}

func launch(_ launchPath: String, with args: [String]? = nil, from directoryPath: String? = nil) -> Process {
    let process = Process()
    process.launchPath = launchPath
    
    if let args = args {
        process.arguments = args
    }
    
    if let directoryPath = directoryPath {
        process.currentDirectoryPath = directoryPath
    }
    
    process.launch()
    
    return process
}

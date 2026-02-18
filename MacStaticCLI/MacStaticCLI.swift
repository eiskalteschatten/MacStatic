//
//  main.swift
//  MacStaticCLI
//
//  Created by Alex Seifert on 16.09.25.
//

import Foundation
import MacStaticCore
import ArgumentParser

@main
struct MacStaticCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "macstatic",
        abstract: "MacStatic CLI tool",
        version: "1.0.0",
        subcommands: [
            Build.self,
            New.self
        ],
        defaultSubcommand: Build.self
    )
}

// MARK: - macstatic build <sourceDir>
struct Build: ParsableCommand {
    @Argument var sourceDir: String?
    
    mutating func run() throws {
        let sourcePath = sourceDir ?? FileManager.default.currentDirectoryPath
        let result = try MacStaticCommandProcessor.processCommand("build", arguments: [sourcePath])
        print(result)
    }
}

// MARK: - macstatic new <name>
struct New: ParsableCommand {
    @Argument var name: String
    
    mutating func run() throws {
        let currentDirectory = FileManager.default.currentDirectoryPath
        let result = try MacStaticCommandProcessor.processCommand("new", arguments: [name, currentDirectory])
        print(result)
    }
}
    

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
        ],
        defaultSubcommand: Build.self
    )
}

// MARK: - macstatic build <sourceDir> <outputDir>
struct Build: ParsableCommand {
    @Argument var sourceDir: String
    @Argument var outputDir: String
    
    mutating func run() throws {
        let builder = SiteBuilder()
        let parsedMarkdown = try builder.build(source: sourceDir, output: outputDir)
        print("Parsed string: \(parsedMarkdown)")
//        FileHandle.standardOutput.write("Built site.\n".data(using: .utf8)!)
    }
}

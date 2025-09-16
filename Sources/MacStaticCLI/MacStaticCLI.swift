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
struct MacStaticCLI: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "macstatic",
        abstract: "MacStatic CLI tool",
        version: "1.0.0"
    )
    
    @Argument(help: "The command to execute")
    var command: String
    
    @Argument(help: "Arguments for the command")
    var arguments: [String] = []
    
    @Flag(help: "Enable verbose output")
    var verbose: Bool = false
    
    mutating func run() async throws {
        // Create core instance on main actor
        let core = await MainActor.run {
            MacStaticCore()
        }
        
        if verbose {
            print("Executing command: \(command) with arguments: \(arguments)")
        }
        
        // Execute the command
        let result = try await core.processCommand(command, arguments: arguments)
        print(result)
    }
}

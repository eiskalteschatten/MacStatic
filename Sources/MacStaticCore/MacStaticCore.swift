//
//  MacStaticCore.swift
//  MacStaticCore
//
//  Created by Alex Seifert on 16.09.25.
//

import Foundation

// Unified command processing - not main actor isolated
public class MacStaticCommandProcessor {
    public static func processCommand(_ command: String, arguments: [String] = []) throws -> String {
        return executeCommand(command: command, arguments: arguments)
    }
    
    // Validate command and arguments
    public static func validateCommand(_ command: String, arguments: [String]) -> (isValid: Bool, message: String) {
        switch command.lowercased() {
        case "build":
            if arguments.count < 2 {
                return (false, "Build command requires source and output paths")
            }
            return (true, "Valid build command")
        case "new":
            return (true, "Valid new command")
        default:
            return (false, "Unknown command: \(command)")
        }
    }
    
    private static func executeCommand(command: String, arguments: [String]) -> String {
        switch command.lowercased() {
        case "build":
            let siteBuilder = SiteBuilder()
            do {
                // Expect arguments: [sourcePath, outputPath]
                let sourcePath = arguments.count > 0 ? arguments[0] : ""
                let outputPath = arguments.count > 1 ? arguments[1] : ""
                let result = try siteBuilder.build(source: sourcePath, output: outputPath)
                return "Site built successfully: \(result)"
            } catch {
                return "Build failed: \(error.localizedDescription)"
            }
        case "new":
            return "New project created: \(arguments[0])"
        default:
            return "Unknown command: \(command)"
        }
    }
}

@MainActor
public class MacStaticCore: ObservableObject {
    @Published public var status: String = "Ready"
    @Published public var isProcessing: Bool = false
    @Published public var results: [String] = []
    
    public init() {}
    
    // Async version for GUI
    public func processCommand(_ command: String, arguments: [String] = []) async throws -> String {
        isProcessing = true
        status = "Processing..."
        
        defer {
            isProcessing = false
            status = "Ready"
        }
        
        let result = await performOperation(command: command, arguments: arguments)
        results.append(result)
        
        return result
    }
    
    private func performOperation(command: String, arguments: [String]) async -> String {
        // Simulate work for GUI
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        return try! MacStaticCommandProcessor.processCommand(command, arguments: arguments)
    }
}
